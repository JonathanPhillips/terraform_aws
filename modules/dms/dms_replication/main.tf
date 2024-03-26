locals {
  use_s3_target = var.target_s3_endpoint_bucket_name != "" && var.target_endpoint_engine_name == ""
  ids = {
    for k, v in var.databases :
    k => {
      source_endpoint = (v.override_source_endpoint_name != ""
        ? v.override_source_endpoint_name
      : "${lower(var.env_name)}-${lower(var.pipeline_name)}-${lower(k)}-source-endpoint")
      target_endpoint = (v.override_target_endpoint_name != ""
        ? v.override_target_endpoint_name
      : "${lower(var.env_name)}-${lower(var.pipeline_name)}-${lower(k)}-to-datalake-target-endpoint")
      replication_task = (v.override_task_name != ""
        ? v.override_task_name
      : "${lower(var.env_name)}-${lower(var.pipeline_name)}-${lower(k)}-to-datalake-replication-task")
    }
  }
  instance_id = (var.override_instance_id != ""
    ? var.override_instance_id
  : "${lower(var.env_name)}-${lower(var.pipeline_name)}-to-datalake-replication-instance")
}

#################################################################################################################
# Instance
#################################################################################################################
resource "aws_dms_replication_instance" "this" {
  allocated_storage            = var.allocated_storage
  apply_immediately            = var.apply_instance_changes_immediately
  allow_major_version_upgrade  = true
  auto_minor_version_upgrade   = true
  engine_version               = "3.5.1"
  kms_key_arn                  = data.aws_kms_alias.dms.target_key_arn
  multi_az                     = var.multi_az
  preferred_maintenance_window = "mon:07:03-mon:07:33"
  publicly_accessible          = false
  replication_instance_class   = var.replication_instance_class
  replication_instance_id      = local.instance_id
  replication_subnet_group_id  = data.aws_dms_replication_subnet_group.main.replication_subnet_group_id
  tags = {
    Name = local.instance_id
  }
  vpc_security_group_ids = [data.aws_security_group.dms_security_group.id]
}

#################################################################################################################
# Endpoint
#################################################################################################################
resource "aws_dms_endpoint" "source" {
  for_each                        = var.databases
  certificate_arn                 = var.source_endpoint_certificate_arn
  database_name                   = each.value.source_endpoint_database_name
  endpoint_id                     = local.ids[each.key].source_endpoint
  endpoint_type                   = "source"
  engine_name                     = var.source_endpoint_engine_name
  extra_connection_attributes     = var.source_endpoint_extra_connection_attributes
  kms_key_arn                     = data.aws_kms_alias.dms.target_key_arn
  port                            = var.source_endpoint_port
  server_name                     = var.source_endpoint_server_name
  service_access_role             = var.source_endpoint_service_access_role
  secrets_manager_access_role_arn = data.aws_iam_role.dms_service_role.arn
  secrets_manager_arn             = data.aws_secretsmanager_secret.source_dms_user.arn
  ssl_mode                        = var.source_endpoint_ssl_mode
  tags = {
    Name = local.ids[each.key].source_endpoint
  }
}

#################################################################################################################
# S3 Endpoint
#################################################################################################################
resource "aws_dms_s3_endpoint" "target" {
  for_each                 = local.use_s3_target ? var.databases : tomap({})
  bucket_name              = var.target_s3_endpoint_bucket_name
  bucket_folder            = "${var.env_name}/${var.pipeline_name}/${each.key}"
  data_format              = "parquet"
  endpoint_id              = local.ids[each.key].target_endpoint
  endpoint_type            = "target"
  include_op_for_full_load = true
  service_access_role_arn  = data.aws_iam_role.dms_service_role.arn
  timestamp_column_name    = "cdc_timestamp"
  tags = {
    Name = local.ids[each.key].target_endpoint
  }
}

#################################################################################################################
# Target Endpoints
#################################################################################################################
resource "aws_dms_endpoint" "target" {
  for_each                        = local.use_s3_target ? tomap({}) : var.databases
  certificate_arn                 = var.target_endpoint_certificate_arn
  database_name                   = var.target_database_name
  endpoint_id                     = local.ids[each.key].target_endpoint
  endpoint_type                   = "target"
  engine_name                     = var.target_endpoint_engine_name
  extra_connection_attributes     = var.target_endpoint_extra_connection_attributes
  kms_key_arn                     = data.aws_kms_alias.dms.target_key_arn
  port                            = var.target_endpoint_port
  server_name                     = var.target_endpoint_server_name
  service_access_role             = var.target_endpoint_service_access_role
  secrets_manager_access_role_arn = data.aws_iam_role.dms_service_role.arn
  secrets_manager_arn             = data.aws_secretsmanager_secret.target_dms_user.arn
  ssl_mode                        = var.target_endpoint_ssl_mode
  tags = {
    Name = local.ids[each.key].target_endpoint
  }
}

#################################################################################################################
# Replication Task
#################################################################################################################
resource "aws_dms_replication_task" "source_to_target_replication_task" {
  for_each                  = var.databases
  cdc_start_time            = var.cdc_start_time
  migration_type            = var.migration_type
  replication_instance_arn  = aws_dms_replication_instance.this.replication_instance_arn
  replication_task_id       = local.ids[each.key].replication_task
  replication_task_settings = var.task_settings
  start_replication_task    = var.start_replication_task
  source_endpoint_arn       = aws_dms_endpoint.source[each.key].endpoint_arn
  table_mappings            = each.value.replication_task_table_mappings
  tags = {
    Name = local.ids[each.key].replication_task
  }
  target_endpoint_arn = local.use_s3_target ? aws_dms_s3_endpoint.target[each.key].endpoint_arn : aws_dms_endpoint.target[each.key].endpoint_arn
}
