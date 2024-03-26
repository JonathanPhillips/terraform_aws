variable "env_name" {
  type        = string
  description = "Required: Pipeline environment name"
}

variable "aws_env_name" {
  type        = string
  description = "Required: AWS Account Environment Name"
}

variable "pipeline_name" {
  type        = string
  description = "A unique name for each conceptual pipeline connecting a source system to the warehouse. Used to create unique resource ids for each pipeline"
}

#region: DMS Instance
variable "replication_instance_class" {
  type        = string
  description = "Required: DMS Replication Instance Class"
}

variable "allocated_storage" {
  type        = string
  description = "Required: DMS Allocated Storage"
}

variable "multi_az" {
  type        = string
  description = "Required: Multi AZ Enabled or Not Enabled (true/false)"
}

variable "apply_instance_changes_immediately" {
  type        = bool
  description = "Optional. Whether to apply the changes now or wait for the next maintance window"
  default     = false
}
#endregion

#region: DMS Endpoints
#region: Source Endpoint
variable "source_endpoint_certificate_arn" {
  type        = string
  description = "ARN for certificate used to connect to DMS Source Endpoint with SSL. Required when SSL Mode is not none."
  default     = ""
}

variable "source_endpoint_engine_name" {
  type        = string
  description = "Required: Engine Name for DMS Source Endpoint"
}

variable "source_endpoint_extra_connection_attributes" {
  type        = string
  description = "Extra Connection Attributes for DMS Source"
  default     = ""
}

variable "source_endpoint_port" {
  description = "The port used by the DMS source endpoint"
  type        = number
  default     = null
}

variable "source_endpoint_server_name" {
  description = "The server name for the DMS source endpoint"
  type        = string
  default     = null
}

variable "source_endpoint_service_access_role" {
  description = "The service access role for the DMS source endpoint"
  type        = string
  default     = null
}

variable "source_endpoint_ssl_mode" {
  type        = string
  description = "SSL Mode for DMS Source Endpoint. Options: none, require, verify-ca, verify-full. AWS Documentation: https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Security.SSL.html"
  default     = "none"
}

variable "source_username_secretsmanager" {
  type        = string
  description = "Required: Secrets Manager secret that includes credentials to authenticate with the database. information supplied."
}
#endregion

#region: Target Endpoint
variable "target_s3_endpoint_bucket_name" {
  type        = string
  description = "DMS S3 Target Endpoint Bucket Name"
  default     = ""
}

variable "target_endpoint_engine_name" {
  type        = string
  description = "Engine Name for DMS target Endpoint"
}

variable "target_database_name" {
  type        = string
  description = "DMS S3 Target Endpoint Bucket Name"
  default     = ""
}

variable "target_endpoint_ssl_mode" {
  type        = string
  description = "SSL Mode for DMS target Endpoint. Options: none, require, verify-ca, verify-full. AWS Documentation: https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Security.SSL.html"
  default     = "none"
}

variable "target_endpoint_certificate_arn" {
  type        = string
  description = "ARN for certificate used to connect to DMS Target Endpoint with SSL. Required when SSL Mode is not none."
  default     = ""
}

variable "target_username_secretsmanager" {
  type        = string
  description = "Required: Secrets Manager secret that includes credentials to authenticate with the database. information supplied."
}

variable "target_endpoint_extra_connection_attributes" {
  type        = string
  description = "Extra Connection Attributes for DMS target"
  default     = ""
}

variable "target_endpoint_server_name" {
  description = "The server name for the DMS target endpoint"
  type        = string
  default     = null
}

variable "target_endpoint_service_access_role" {
  description = "The service access role for the DMS target endpoint"
  type        = string
  default     = null
}

variable "target_endpoint_port" {
  description = "The port used by the DMS target endpoint"
  type        = number
  default     = null
}
#endregion

#region: DMS Task
variable "cdc_start_time" {
  type        = number
  description = "Required: DMS CDC Start Time"
  default     = 0
}

variable "migration_type" {
  type        = string
  description = "Required: DMS Migration Type (full-load | cdc | full-load-and-cdc)"
  default     = "full-load-and-cdc"
}

variable "task_settings" {
  type        = string
  description = "DMS Replication Task JSON Settings"
  default     = ""
}

variable "start_replication_task" {
  type        = bool
  description = "DMS Start Replication Task"
  default     = false
}
#endregion

#region: Database
variable "databases" {
  type = map(object({
    source_endpoint_database_name   = string
    replication_task_table_mappings = string
    override_source_endpoint_name   = optional(string, "")
    override_target_endpoint_name   = optional(string, "")
    override_task_name              = optional(string, "")
  }))
  description = "Required: Properties specific to the replication task/endpoints for each database replicated from a source"
}
#endregion

#region: Override
variable "override_instance_id" {
  type        = string
  description = "Override instance id"
  default     = ""
}

variable "override_subnet_group" {
  type        = string
  description = "Override subnet group name"
  default     = ""
}

variable "override_service_role" {
  type        = string
  description = "Override service role name"
  default     = ""
}

#endregion
