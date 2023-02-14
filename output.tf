output "RDSInstances" {
   value = toset([
    for dbinstance in aws_db_instance.dbinstances : 
    {
      "db_instance_identifier" = dbinstance.db_instance_identifier,
      "engine" = dbinstance.engine,
      "engine_version" = dbinstance.engine_version,
      "master_username" = dbinstance.master_username,
      "db_name" = dbinstance.db_name,
      "multi_az" = dbinstance.multi_az,
      "endpoint" = dbinstance.address
    }
  ])
}

output "RDSClusters" {
  value = toset([
    for dbcluster in aws_rds_cluster.dbclusters :
    {
      "cluster_identifier" = dbcluster.cluster_identifier,
      "engine" = dbcluster.engine,
      "engine_version" = dbcluster.engine_version,
      "master_username" = dbcluster.master_username,
      "db_name" = dbcluster.database_name,
      "availability_zones" = dbcluster.availability_zones,
      "endpoint" = dbcluster.endpoint
    }
  ])
}

output "DefaultTags" {
  value = var.tags
}