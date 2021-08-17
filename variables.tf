variable "AWS_REGION" {
    type = string
}

variable "AWS_CF_ORIGIN_ID" {
    type = string
    description = "S3 origin id"
}

variable "AWS_CF_DESCRIPTION" {
    type = string
    description = "CloudFront description"
}

variable "AWS_R53_HOSTED_ZONE" {
    type = string
    description = "Root domain"
}

variable "AWS_R53_RECORD" {
    type = string
    description = "Subdomain"
}

variable "AWS_TAGS_Environment" {
    type = string
    description = "Environment Tag"
}

variable "AWS_TAGS_Name" {
    type = string
    description = "Name Tag"
}