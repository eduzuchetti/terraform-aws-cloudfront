# Introduction 
Module for create CloudFormation, S3 and Route53 Record for static content like web applications built in React or Vue.

<br>

# Whats this module creates?
- CloudFront
- Route53 Record
- S3 Bucket named with DNS
- All other related resourcess (Bucket Policies, OriginID, etc...)

<br>

# How to use this Module
Create a module resource with this repo as source:
```
module "cloudfront" {
  source = "eduzuchetti/cloudfront/aws"
  version = "1.0.0"

  cdns = [
    "site1" = {
      AWS_REGION          = "us-east-1"
      AWS_R53_HOSTED_ZONE = "example.com"
      AWS_R53_FQDN        = "site1.example.com"
      AWS_CF_ORIGIN_ID    = "OriginBucket-Site1"
      AWS_CF_DESCRIPTION  = "CDN for Site1"
      AWS_CF_ORIGIN_PATH  = "/www"
      AWS_CF_ROOT_OBJECT  = "index.html"
      AWS_CF_CERTIFICATE  = "TLSv1.2_2021"
    },
    "site2" = {
      AWS_REGION          = "us-east-1"
      AWS_R53_HOSTED_ZONE = "example.com"
      AWS_R53_FQDN        = "site2.example.com"
      AWS_CF_ORIGIN_ID    = "OriginBucket-Site2"
      AWS_CF_DESCRIPTION  = "CDN for Site2"
      AWS_CF_ORIGIN_PATH  = "/www"
      AWS_CF_ROOT_OBJECT  = "index.html"
      AWS_CF_CERTIFICATE  = "TLSv1.2_2021"
    }
  ]
}
