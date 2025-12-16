# Introduction 
Module for create CloudFormation, S3 and Route53 Record for static content like web applications built in React or Vue.

The original repo is on github! Check here [ezuchetti/terraform-aws-cloudfront](https://github.com/ezuchetti/terraform-aws-cloudfront)

Also check the module in de Teraform Registry: [eduzuchetti/cloudfront/aws](https://registry.terraform.io/modules/eduzuchetti/cloudfront/aws)

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
      AWS_CF_CERTIFICATE  = "TLSv1.3_2025"
    },
    "site2" = {
      AWS_REGION          = "us-east-1"
      AWS_R53_HOSTED_ZONE = "example.com"
      AWS_R53_FQDN        = "site2.example.com"
      AWS_CF_ORIGIN_ID    = "OriginBucket-Site2"
      AWS_CF_DESCRIPTION  = "CDN for Site2"
      AWS_CF_ORIGIN_PATH  = "/www"
      AWS_CF_ROOT_OBJECT  = "index.html"
      AWS_CF_CERTIFICATE  = "TLSv1.3_2025"
    }
  ]
}
```

