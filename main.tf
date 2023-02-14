# S3 Bucket and IAM Policies
resource "aws_s3_bucket" "cf_bucket" {
  for_each = var.cdns

  bucket      = each.value.AWS_R53_FQDN
  acl         = "private"

  tags        = {
    Name    = "${each.value.AWS_R53_FQDN}"
  }
}

resource "aws_s3_bucket_policy" "cf_bucket" {
  for_each = var.cdns

  bucket = aws_s3_bucket.cf_bucket[each.key].id
  policy = data.aws_iam_policy_document.s3_policy[each.key].json
}

resource "aws_s3_bucket_public_access_block" "cf_bucket" {
  for_each = var.cdns
  
  bucket                  = aws_s3_bucket.cf_bucket[each.key].id

  block_public_acls       = true
  block_public_policy     = true

  ignore_public_acls      = true
  restrict_public_buckets = true

  depends_on              = [
    aws_s3_bucket_policy.cf_bucket
  ]
}

# CloudFront and OriginAccessIdentity
resource "aws_cloudfront_origin_access_identity" "oai" {
  for_each = var.cdns

  comment = each.value.AWS_CF_ORIGIN_ID
}

resource "aws_cloudfront_distribution" "cf_distribution" {
  for_each = {
    for k, v in var.cdns : k => {
      hosted_zone     = v.AWS_R53_HOSTED_ZONE
      fqdn            = v.AWS_R53_FQDN
      cf_origin_id    = v.AWS_CF_ORIGIN_ID
      cf_description  = v.AWS_CF_DESCRIPTION
      cf_origin_path  = v.AWS_CF_ORIGIN_PATH
      cf_root_object  = v.AWS_CF_ROOT_OBJECT
    }
  }

  origin {
    domain_name = aws_s3_bucket.cf_bucket[each.key].bucket_regional_domain_name
    origin_id   = each.value.cf_origin_id
    origin_path = each.value.cf_origin_path

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai[each.key].cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = each.value.cf_description
  default_root_object = each.value.cf_root_object

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  tags = {
    Name  = "${each.value.fqdn}"
  }

  viewer_certificate {
    acm_certificate_arn      = data.aws_acm_certificate.cert_hosted_zone[each.key].arn
    minimum_protocol_version = "TLSv1.2_2021"
    ssl_support_method       = "sni-only"
  }

  aliases = [each.value.fqdn]

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = each.value.cf_origin_id
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress               = true

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  depends_on = [aws_s3_bucket.cf_bucket]
}

# Route53 Record
resource "aws_route53_record" "cf_record" {
  for_each  = var.cdns

  zone_id   = data.aws_route53_zone.zone[each.key].zone_id
  name      = each.value.AWS_R53_FQDN
  type      = "A"

  alias {
    name                   = aws_cloudfront_distribution.cf_distribution[each.key].domain_name
    zone_id                = aws_cloudfront_distribution.cf_distribution[each.key].hosted_zone_id
    evaluate_target_health = true
  }
}