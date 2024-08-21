variable "azure_group_name" {
  type        = string
  description = "AzureAD SSO group name"
}

variable "aws_account_id" {
  type        = string
  description = "AWS Account ID"
}

variable "permission_set_arn" {
  type        = string
  description = "Permission set arn"
}

variable "instance_arn" {
  type        = string
  description = "AWS SSO integrated instance arn"
}

variable "identity_store_id" {
  type        = string
  description = "AWS Identity store id"
}
