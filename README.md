# Introduction 
Module for create RDS Instances and Clusters

<br>

# Whats this module creates?
- [RDS Instances](#how-to-use-this-module-to-create-a-rds-instance)
- [RDS Clusters](#how-to-use-this-module-to-create-a-rds-cluster)

<br>

# How to use this Module to create a RDS Cluster
Simple example code of how to create a RDS Cluster with [Aurora Serverless v1 - MySQl 5.7](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-serverless.html) engine with Autopause settings.

This is ideal for development environment as the DB Cluster is Stopped (Paused) if there is no active connection, and you'll only be charged for the storage in use while the cluster is in paused.

<br>

Check the oficial docs of the [RDS Cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster) section of [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws) for any doubts of how to fill the variable values

<br>

## Create a module resource with this source:
```terraform
module "rds" {
  source = "app.terraform.io/eduardo_zuchetti/rds/aws"
}
```

## Declare the variable "rds_clusters"
You can declare this variable as "any", but I recomend to use the entire definition.

<br>

### Declare as "any":
```terraform
variable "rds_clusters" {
  description = "Map of values for multiple RDS clusters"
  type = map(any)
  default = {}
```

<br>

### Declare entire Map of Objects (recomended):
```terraform
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
```

<br>

## Set the appropriate values for variable "rds_clusters"

If you choose to set the entire definition, let all unused options as **NULL**


```tfvars
rds_clusters = {
  "dbcluster-blog" = {
    allocated_storage           = null
    storage_type                = null
    availability_zones          = ["us-east-1a", "us-east-1b", "us-east-1c"]
    allow_major_version_upgrade = false
    cluster_identifier          = "db-aurora-mysql-blog"
    cluster_identifier_prefix   = null
    copy_tags_to_snapshot       = true
    database_name               = "master"
    db_cluster_instance_class   = null
    deletion_protection         = false
    engine                      = "aurora-mysql"
    engine_mode                 = "serverless"
    engine_version              = "5.7.mysql_aurora.2.07.1"
    global_cluster_identifier   = null
    iam_roles                   = []
    iops                        = null
    master_password             = "MyStrongPassword"
    master_username             = "master"
    vpc_security_group_ids      = []
    
    # Set null if you are using the Serverless V2
    scaling_configuration = {
      auto_pause                = true
      max_capacity              = 4
      min_capacity              = 1
      seconds_until_auto_pause  = 300
      timeout_action            = "ForceApplyCapacityChange"
    }
    
    # Set null if you are using the Serverless V1
    serverlessv2_scaling_configuration = null
  }
}
```

# How to use this Module to create a RDS Instance
Simple example code of how to create a RDS Instance with [Aurora Serverless v1 - MySQl 5.7](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-serverless.html) engine

Check the oficial docs of the [RDS Cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster) section of [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws) for any doubts of how to fill the variable values

<br>

## Declare the variable "rds_instances"
You can declare this variable as "any", but I recomend to use the entire definition.

<br>

### Declare as "any":
```terraform
variable "rds_instances" {
  description = "Map of values for multiple RDS Instances"
  type = map(any)
  default = {}
```

<br>

### Declare entire Map of Objects (recomended):
```terraform
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
```

<br>

## Set the appropriate values for variable "rds_clusters"

If you choose to set the entire definition, let all unused options as **null**


```tfvars
rds_instances = {
  "dbinstance-blog" = {
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
      vpc_security_group_ids      = []
      publicly_accessible         = false
      allow_major_version_upgrade = true
      auto_minor_version_upgrade  = false
      copy_tags_to_snapshot       = true
      multi_az                    = false
    }
  }
}
```