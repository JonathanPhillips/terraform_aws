terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.1.0"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "us-east-1"
  profile = "mfa-${lower(var.aws_env_name)}"
  default_tags {
    tags = {
      "Environment" = "${upper(var.aws_env_name)}"
      "ManagedBy"   = "Terraform"
      "Module"      = "dms_subnet_group"
    }
  }
}
