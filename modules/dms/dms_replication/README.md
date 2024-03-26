# DMS Module

This Terraform module sets up an AWS Database Migration Service (DMS) infrastructure to replicate databases to an AWS S3 bucket in parquet format. It includes the creation of DMS replication instances, source endpoints, target S3 endpoints, and replication tasks. The module is designed to handle multiple databases through a dynamic setup configured by the input variables.

## Importing module
- When importing module follow the folowing structure
- `envs/<provider>/<env>/<account>/<region>/<service>/<module>`

- example:
-- `envs/aws/dev/sandbox/us-west-1/dms/dms-replication`

## Pre-requisites
- Networking Infrastructure: The VPC, subnet, and security group IDs referenced in the module should already exist.
- KMS Key: A KMS key with the alias defined as alias/AWS-KEY-${upper(var.aws_env_name)}-DMS should exist for encryption.
- AWS Secrets Manager Secret: This module requires a specific configuration in AWS Secrets Manager to securely store and retrieve sensitive information.
- S3 Bucket: An S3 bucket named as per the dms_target_s3_endpoint_bucket_name variable should exist if it's being used as a target for DMS.
- Certificate for SSL: If SSL mode is not none, a valid certificate ARN for the DMS source endpoint must be provided.

## Argument Reference
The following arguments are supported:

### General Arguments
General arguments are used to configure the replication instance and other general settings related to DMS.

- `env_name` - (Required) The environment name used to construct unique identifiers for resources.
- `aws_env_name` - (Required) AWS Account Environment Name, which might be used for setting up provider configurations or for distinguishing resources in multi-account setups.
- `pipeline_name` - (Required) A unique name for the pipeline, used in naming conventions for creating AWS DMS resources.
- `replication_instance_class` - (Required) Specifies the compute and memory capacity of the AWS DMS replication instance.
- `allocated_storage` - (Required) The amount of storage (in gigabytes) to be initially allocated for the replication instance.
- `multi_az` - (Required) Boolean flag to enable or disable Multi-AZ deployment for the replication instance.
- `migration_type` - (Required) The migration type for the DMS task (full-load | cdc | full-load-and-cdc).
- `start_replication_task` - (Optional) DMS Start Replication Task option.
- `apply_instance_changes_immediately` - (Optional) Determines whether the replication instance changes should be applied immediately or during the next maintenance window.
- `cdc_start_time` - (Optional) The start time for the Change Data Capture (CDC) operation.
- `task_settings` - (Optional) The settings for the DMS replication task in JSON format.
- `tags` - (Optional) A map of tags that are applied to all taggable resources.

### Source Arguments
Source arguments are used to configure the source of data for DMS Tasks. Multiple sources can be used by using the `databases` argument.

- `source_endpoint_engine_name` - (Required) The engine name of the DMS source endpoint.
- `source_username_secretsmanager` - (Required) Secrets Manager secret that includes credentials to authenticate with the database. information supplied.
- `source_endpoint_ssl_mode` - (Optional) The SSL mode to use for the connection to the source endpoint.
- `source_endpoint_certificate_arn` - (Required when source_endpoint_ssl_mode is not none) The Amazon Resource Name (ARN) of the certificate used for SSL connection to the source endpoint.
- `source_endpoint_port` - (Optional) The port used by the DMS source endpoint for connections.
- `source_endpoint_extra_connection_attributes` - (Optional) Additional connection attributes used to connect to the source endpoint.
- `source_endpoint_server_name` - (Optional) The server name for the DMS source endpoint.
- `source_endpoint_service_access_role` - (Optional) The IAM role used by DMS to access the source endpoint.
- `databases` - (Required) A map of objects, each representing database-specific configurations for replication tasks and endpoints. Each object includes:
  - `source_endpoint_database_name` - (Required) The name of the source database for the endpoint.
  - `replication_task_table_mappings` - (Required) The table mappings for the replication task, specifying which tables to include or exclude from replication.
  - `Overrides` (See "Source Database Overrides" section below)


source_username_secretsmanager
### Target Arguments
Target arguments are used to configure the target of data for DMS Tasks. One target is created per module. An S3 target or a database target must be configured (Not both).

- `target_s3_endpoint_bucket_name` - (Required if using S3 target) The name of the S3 bucket to be used as the target endpoint for AWS DMS.
- `target_endpoint_engine_name` - (Required if using DB target) The engine name of the DMS target endpoint.
- `target_database_name` - (Required if using DB target) The name of the target database for the endpoint.
- `target_username_secretsmanager` - (Required if using DB target) Secrets Manager secret that includes credentials to authenticate with the database. information supplied.
- `target_endpoint_ssl_mode` - (Optional) The SSL mode to use for the connection to the target endpoint.
- `target_endpoint_certificate_arn` - (Required when target_endpoint_ssl_mode is not none) The Amazon Resource Name (ARN) of the certificate used for SSL connection to the target endpoint.
- `target_endpoint_port` - (Optional) The port used by the DMS target endpoint for connections.
- `target_endpoint_extra_connection_attributes` - (Optional) Additional connection attributes used to connect to the target endpoint.
- `target_endpoint_server_name` - (Optional) The server name for the DMS target endpoint.
- `target_endpoint_service_access_role` - (Optional) The IAM role used by DMS to access the source endpoint.

### Override Reference (All argurments are optional)
The following arguments are supported and are used to override the names of different resources.
These arguments are recommended to only be used when importing resources into a Terraform module. This helps the transition process by ensuring no resources require redeployment.

- `override_instance_id` - This field overrides the default instance id determined by the module.
- `override_subnet_group` - This field overrides the default subnet group used by the module.
- `override_service_role` - This field overrides the default service role used by the module.

#### Source Database Overrides
The following override arguments are supported within the `databases` argument.

- `override_source_endpoint_name` - This field overrides the default source endpoint name determined by the module.
- `override_target_endpoint_name` - This field overrides the default target endpoint name  determined by the module.
- `override_task_name` - This field overrides the default task name determined by the module.

## Outputs

Upon successful creation of the AWS DMS resources, the following outputs will be available:
- `replication_instance_arn:` The ARN of the DMS replication instance.
- `source_endpoints:` A map of the source endpoints and their details.
- `s3_target_endpoints:` A map of the S3 target endpoints and their details.
- `replication_tasks:` A map of the replication tasks and their details.
For more specific details on the output values, users should refer to the actual output definitions in the Terraform configuration.


## Examples
This example shows a basic configuration of the module.
```terraform
module "database_migration_service" {
  source  = "/modules/aws/dms/dms_replication"

  env_name              = "dev"
  aws_env_name          = "sandbox"
  pipeline_name         = "dms-pipeline"
  override_instance_id  = "dmsinstance01"
  override_subnet_group = "dms-sandbox-subnet-group"
  override_service_role = "DataMigrationServiceRole"

  replication_instance_class         = "dms.c4.large"
  allocated_storage                  = 200
  multi_az                           = true
  apply_instance_changes_immediately = false

  source_endpoint_engine_name     = "oracle"
  source_endpoint_ssl_mode        = "verify-ca"
  source_endpoint_certificate_arn = "arn:aws:dms:us-west-1:012345678:cert:ABCDEFGHIJKLMNOPQRSTUVWXYZ"
  # source_username_secretsmanager  = <name_of_secret>"

  migration_type         = "full-load-and-cdc"
  task_settings          = file("${path.module}/task-settings.json")
  start_replication_task = false
  cdc_start_time         = null

  target_endpoint_engine_name     = "postgres"
  target_database_name            = "DB_NAME"
  target_endpoint_ssl_mode        = "verify-ca"
  target_endpoint_certificate_arn = "arn:aws:dms:us-west-1:012345678:cert:ABCDEFGHIJKLMNOPQRSTUVWXYZ"
  # target_username_secretsmanager  = "<name_of_secret"

  databases = {
    "DBNAME" = {
      source_endpoint_database_name   = "DBNAME"
      replication_task_table_mappings = file("${path.module}/table-mappings.json")
      override_source_endpoint_name   = "postgres01"
      override_target_endpoint_name   = "postgres02"
      override_task_name              = "postgres-to-postgres-task"
    }
  }
}
```
