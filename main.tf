# S3 Bucket and IAM Policies
resource "aws_s3_bucket" "cf_bucket" {
  bucket  = "${var.AWS_R53_RECORD}.${var.AWS_R53_HOSTED_ZONE}"
  acl     = "private"

  tags    = {
    Name        = "${var.AWS_R53_RECORD}.${var.AWS_R53_HOSTED_ZONE}"
    Environemnt = var.AWS_TAGS_Environment
  }
}

resource "aws_s3_bucket_policy" "cf_bucket" {
  bucket = aws_s3_bucket.cf_bucket.id
  policy = data.aws_iam_policy_document.s3_policy.json
}

resource "aws_s3_bucket_public_access_block" "cf_bucket" {
  bucket                  = aws_s3_bucket.cf_bucket.id

  block_public_acls       = true
  block_public_policy     = true

  ignore_public_acls      = true
  restrict_public_buckets = true

  depends_on              = [
    aws_s3_bucket_policy.cf_bucket
  ]
}

# CloudFront and OriginAccessIdentity
resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "${var.AWS_TAGS_Environment} Origin of ${var.AWS_CF_DESCRIPTION}"
}

resource "aws_cloudfront_distribution" "cf_distribution" {
  origin {
    domain_name = aws_s3_bucket.cf_bucket.bucket_domain_name
    origin_id   = var.AWS_CF_ORIGIN_ID
    origin_path = "/current"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = var.AWS_CF_DESCRIPTION
  default_root_object = "index.html"

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  tags = {
    Name        = "${var.AWS_R53_RECORD}.${var.AWS_R53_HOSTED_ZONE}"
    Environemnt = var.AWS_TAGS_Environment
  }

  viewer_certificate {
    acm_certificate_arn      = data.aws_acm_certificate.cert_hosted_zone.arn
    minimum_protocol_version = "TLSv1.2_2018"
    ssl_support_method       = "sni-only"
  }

  aliases = ["${var.AWS_R53_RECORD}.${var.AWS_R53_HOSTED_ZONE}"]

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = var.AWS_CF_ORIGIN_ID
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
