variable "aws_env" {
  type        = string
  description = "AWS Account short name"
}

variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "us-east-1"
}

variable "vpc_id" {
  type        = string
  description = "AWS VPC ID"
}
