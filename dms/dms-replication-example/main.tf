module "dms-replication-connect-sqlserver-to-s3" {
  source = "../../modules/dms/dms_replication"


  env_name              = "sandbox"
  aws_env_name          = "sandbox"
  pipeline_name         = "example-pipeline"
  override_instance_id  = "dmsinstance01"
  override_subnet_group = "dms-prod-subnet-group"
  override_service_role = "DataMigrationServiceRole"

  replication_instance_class         = "dms.c4.large"
  allocated_storage                  = 100
  multi_az                           = true
  apply_instance_changes_immediately = false

  source_endpoint_engine_name     = "postgres"
  source_endpoint_ssl_mode        = "verify-ca"
  source_endpoint_certificate_arn = ""
  source_username_secretsmanager  = ""

  migration_type         = "full-load-and-cdc"
  task_settings          = file("${path.module}/task-settings.json")
  start_replication_task = false
  cdc_start_time         = null

  target_endpoint_engine_name     = "postgres"
  target_database_name            = "RDSNAME"
  target_endpoint_ssl_mode        = "verify-ca"
  target_endpoint_certificate_arn = ""
  target_username_secretsmanager  = ""

  databases = {
    "DBNAME" = {
      source_endpoint_database_name   = "DBNAME"
      replication_task_table_mappings = file("${path.module}/table-mappings.json")
      override_source_endpoint_name   = ""
      override_target_endpoint_name   = ""
      override_task_name              = "db1-to-db2-task"
    }
  }
}
