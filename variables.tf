variable "cdns" {
  description = "Map of values for multi cdns"
  type = map(
    object({
      AWS_REGION          = string
      AWS_CF_ORIGIN_ID    = string
      AWS_CF_DESCRIPTION  = string
      AWS_CF_ORIGIN_PATH  = string
      AWS_CF_ROOT_OBJECT  = string
      AWS_CF_CERTIFICATE  = string
      AWS_R53_HOSTED_ZONE = string
      AWS_R53_FQDN        = string
    })
  )
}

variable "tags" {
  description = "Map of Tags to apply on all resources"
  type        = map(any)
  default     = {}
}