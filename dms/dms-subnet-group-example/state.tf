terraform {
  backend "s3" {
    bucket         = "terraform-states"
    key            = "aws/us-west-2/dms/dms-subnet-group/terraform.tfstate"
    encrypt        = true
    kms_key_id     = ""
    region         = "us-west-2"
    profile        = "sandbox"
    dynamodb_table = "TerraformStateLock"
  }
}
