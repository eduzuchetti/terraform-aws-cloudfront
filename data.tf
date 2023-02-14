data "aws_acm_certificate" "cert_hosted_zone" {
  for_each = var.cdns

  domain   = "*.${each.value.AWS_R53_HOSTED_ZONE}"
  statuses = ["ISSUED"]
}

data "aws_iam_policy_document" "s3_policy" {
  for_each = var.cdns

  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.cf_bucket[each.key].arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.oai[each.key].iam_arn]
    }
  }

  statement {
    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.cf_bucket[each.key].arn]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.oai[each.key].iam_arn]
    }
  }
}

data "aws_route53_zone" "zone" {
  for_each = var.cdns

  name         = each.value.AWS_R53_HOSTED_ZONE
  private_zone = false
}