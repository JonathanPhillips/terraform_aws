module "dms-replication-main-subnet-group" {
  source = "../../../modules/dms/dms_subnet_group"

  aws_env_name = "sandbox"
}
