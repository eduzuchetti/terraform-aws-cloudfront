output "AWS_S3_BUCKET_NAME" {
   value = toset([
    for bucket in aws_s3_bucket.cf_bucket : bucket.bucket
  ])
}

output "AWS_CF_ID" {
  value = toset([
    for cf in aws_cloudfront_distribution.cf_distribution : cf.id
  ])
}

output "AWS_CF_ARN" {
  value = toset([
    for cf in aws_cloudfront_distribution.cf_distribution : cf.arn
  ])
}

output "AWS_CF_DOMAIN_NAME" {
  value = toset([
    for cf in aws_cloudfront_distribution.cf_distribution : cf.domain_name
  ])
}