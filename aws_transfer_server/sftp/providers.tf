terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.41.0"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-1"
  profile = "${lower(var.aws_env)}"

  default_tags {
    tags = {
      "Environment" = "${upper(var.aws_env)}"
    }
  }
}
