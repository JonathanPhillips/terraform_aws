variable "aws_env_name" {
  type        = string
  description = "Required: AWS Account Environment Name"
}

variable "oracle_cert_filename" {
  type        = string
  description = "Name of the file to use for the Oracle certificate."
  default     = ""
}

variable "postgres_cert_filename" {
  type        = string
  description = "Name of the file to use for the Postgres certificate."
  default     = ""
}
