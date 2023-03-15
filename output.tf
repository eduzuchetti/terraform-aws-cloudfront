output "CloudFronts" {
  value = aws_cloudfront_distribution.cf_distribution
}

output "Buckets" {
  value = aws_s3_bucket.cf_bucket
}