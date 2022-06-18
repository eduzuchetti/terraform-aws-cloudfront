# This rds.tf must be replaced by a module for each RDS instance.
resource "aws_db_instance" "dbinstances" {
  for_each = var.rds_instances

  identifier                  = each.value.db_instance_identifier
  instance_class              = each.value.db_instance_class

  storage_type                = lookup(each.value, "storage_type", "gp2")
  allocated_storage           = each.value.allocated_storage
  max_allocated_storage       = lookup(each.value, "max_allocated_storage", null)

  engine                      = each.value.engine
  engine_version              = each.value.engine_version
  license_model               = lookup(each.value, "license_model", null)

  username                    = lookup(each.value, "master_username", "master")
  password                    = each.value.master_password
  db_name                     = each.value.db_name

  vpc_security_group_ids      = lookup(each.value, "vpc_security_group_ids", null)
  publicly_accessible         = lookup(each.value, "publicly_accessible", false)

  allow_major_version_upgrade = lookup(each.value, "allow_major_version_upgrade", false)
  auto_minor_version_upgrade  = lookup(each.value, "auto_minor_version_upgrade", false)

  copy_tags_to_snapshot       = lookup(each.value, "copy_tags_to_snapshot", true)
  multi_az                    = lookup(each.value, "multi_az", false)
}

resource "aws_rds_cluster" "dbclusters" {
  for_each = var.rds_clusters

  allocated_storage           = each.value.allocated_storage
  storage_type                = each.value.storage_type
  availability_zones          = each.value.availability_zones
  allow_major_version_upgrade = each.value.allow_major_version_upgrade
  cluster_identifier          = each.value.cluster_identifier
  cluster_identifier_prefix   = each.value.cluster_identifier_prefix
  copy_tags_to_snapshot       = each.value.copy_tags_to_snapshot
  database_name               = each.value.database_name
  db_cluster_instance_class   = each.value.db_cluster_instance_class
  deletion_protection         = each.value.deletion_protection
  engine                      = each.value.engine
  engine_mode                 = each.value.engine_mode
  engine_version              = each.value.engine_version
  global_cluster_identifier   = each.value.global_cluster_identifier
  iam_roles                   = each.value.iam_roles
  iops                        = each.value.iops
  master_password             = each.value.master_password
  master_username             = each.value.master_username
  vpc_security_group_ids      = each.value.vpc_security_group_ids

  dynamic "scaling_configuration" {
    for_each = each.value.engine_mode == "serverless" ? [1] : []

    content {
      auto_pause               = each.value.scaling_configuration.auto_pause
      max_capacity             = each.value.scaling_configuration.max_capacity
      min_capacity             = each.value.scaling_configuration.min_capacity
      timeout_action           = each.value.scaling_configuration.timeout_action
      seconds_until_auto_pause = each.value.scaling_configuration.seconds_until_auto_pause
    }
  }

  dynamic "serverlessv2_scaling_configuration" {
    for_each = each.value.engine_mode == "provisioned" ? [1] : []

    content {
      max_capacity             = each.value.scaling_configuration.max_capacity
      min_capacity             = each.value.scaling_configuration.min_capacity
    }
  }
}