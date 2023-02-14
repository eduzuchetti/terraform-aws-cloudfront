variable "rds_instances" {
  description = "Map os values for multiple RDS instances"
  type = map(
    object({
      db_instance_class           = string
      db_instance_identifier      = string
      allocated_storage           = number
      max_allocated_storage       = number
      storage_type                = string
      engine                      = string
      engine_version              = string
      license_model               = string
      master_username             = string
      master_password             = string
      db_name                     = string
      vpc_security_group_ids      = list(string)
      publicly_accessible         = bool
      allow_major_version_upgrade = bool
      auto_minor_version_upgrade  = bool
      copy_tags_to_snapshot       = bool
      multi_az                    = bool
    })
  )
  default = {}
}

variable "rds_clusters" {
  description = "Map of values for multiple RDS clusters"
  type = map(
    object({
      allow_major_version_upgrade = bool
      availability_zones          = list(string)
      cluster_identifier_prefix   = string
      cluster_identifier          = string
      global_cluster_identifier   = string
      deletion_protection         = bool
      vpc_security_group_ids      = list(string)
      copy_tags_to_snapshot       = bool

      engine         = string
      engine_mode    = string
      engine_version = string
      iam_roles      = list(string)

      db_cluster_instance_class = string
      allocated_storage         = number
      storage_type              = string
      iops                      = number

      master_username = string
      master_password = string
      database_name   = string

      scaling_configuration = object({
        auto_pause               = bool
        max_capacity             = number
        min_capacity             = number
        seconds_until_auto_pause = number
        timeout_action           = string
      })

      serverlessv2_scaling_configuration = object({
        min_capacity = number
        max_capacity = number
      })
    })
  )
  default = {}
}

variable "tags" {
  description = "Map of Tags to apply on all resources"
  type        = map(any)
  default     = {}
}
