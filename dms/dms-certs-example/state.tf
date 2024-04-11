terraform {
  backend "s3" {
    bucket         = "terraform-states"
    key            = "/aws/us-west-2/dms/dms-certs/terraform.tfstate"
    encrypt        = true
    kms_key_id     = ""
    region         = "us-east-1"
    profile        = "sandbox"
    dynamodb_table = "TerraformStateLock"
  }
}
