variable "name" {
  type        = string
  description = "PermissionSet name"
}

variable "description" {
  type        = string
  description = "PermissionSet description"
}

variable "session_duration" {
  type        = string
  description = "AWS format session duration"
  default     = "PT2H"
}

variable "tags" {
  description = "AWS Tags"
}

variable "inline_policy" {
  default     = ""
  description = "AWS IAM Policy"
}

variable "associations" {
  type = list(object({
    aws_account_id   = string
    azure_group_name = string
  }))
  description = "AWS account and Azure SSO group association map"
}

variable "managed_policies" {
  description = "AWS Managed IAM Policies ARN list"
  type        = list(string)
  default     = []
}

variable "customer_managed_policies" {
  description = "Customer Managed IAM Policies ARN list"
  type        = list(string)
  default     = []
}

variable "dummy_input_for_dependency" {
  description = "A dummy input to create explicit module dependencies"
  type        = string
  default     = ""
}
