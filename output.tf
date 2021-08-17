output "AWS_S3_BUCKET_NAME" {
    value = aws_s3_bucket.cf_bucket.bucket
}

output "AWS_CF_ID" {
    value = aws_cloudfront_distribution.cf_distribution.id
}

output "AWS_CF_ARN" {
    value = aws_cloudfront_distribution.cf_distribution.arn
}

output "AWS_CF_DOMAIN_NAME" {
    value = aws_cloudfront_distribution.cf_distribution.domain_name
}