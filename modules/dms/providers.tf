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
  region  = "us-west-1"
  profile = "sso-${lower(var.aws_env_name)}"
  default_tags {
    tags = {
      "Environment" = "${upper(var.aws_env_name)}"
      "ManagedBy"   = "Terraform"
      "Module"      = "dms_certificate"
    }
  }
}
