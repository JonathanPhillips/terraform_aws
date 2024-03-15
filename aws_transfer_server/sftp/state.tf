terraform {
  backend "s3" {
    bucket  = "terraform-states"
    key     = "aws/us-east-1/sftp_transfer_family/sftp/terraform.tfstate"
    region  = "us-east-1"
    profile = "mfa"
  }
}
