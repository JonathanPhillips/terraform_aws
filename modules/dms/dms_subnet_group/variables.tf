variable "aws_env_name" {
  type        = string
  description = "Required: AWS Account Environment Name"
}

variable "override_subnet_group_name" {
  type        = string
  description = "This will override the default subnet group name of <aws_env_name>-subnet-group"
  default     = ""
}
