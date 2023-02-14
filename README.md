# Introduction 
Module for create CloudFormation, S3 and Route53 Record for static content like web applications built in React or Vue.

# How to use this Module
Configure you project with a aws provider
```
# file: providers.tf

provider "aws" {
  region = "us-east-1"
  profile = "my-profile"
}
```

Create a module resource with this repo as source:
```
module "cf" {
  source = "git@vs-ssh.visualstudio.com:v3/eduzuchetti/IAC/tf-aws-cloudfront"

  cdns = [
    {
      AWS_REGION            = "us-east-1"
      AWS_CF_ORIGIN_ID      = "OriginId-ExampleCom"
      AWS_CF_DESCRIPTION    = "Managed by Terraform."
      AWS_R53_HOSTED_ZONE   = "example.com"
      AWS_R53_RECORD        = "blog"
    },
    {
      AWS_REGION            = "us-east-1"
      AWS_CF_ORIGIN_ID      = "OriginId-ExampleCom"
      AWS_CF_DESCRIPTION    = "Managed by Terraform."
      AWS_R53_HOSTED_ZONE   = "example.com"
      AWS_R53_RECORD        = "awesome"
    },
    {
      AWS_REGION            = "us-east-1"
      AWS_CF_ORIGIN_ID      = "OriginId-ExampleCom"
      AWS_CF_DESCRIPTION    = "Managed by Terraform."
      AWS_R53_HOSTED_ZONE   = "example.com"
      AWS_R53_RECORD        = "business"
    }
  ]
}

```