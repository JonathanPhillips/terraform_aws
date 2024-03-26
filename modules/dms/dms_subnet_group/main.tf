locals {
  use_override_name = var.override_subnet_group_name != ""
  subnet_group_id   = local.use_override_name ? var.override_subnet_group_name : "${lower(var.aws_env_name)}-subnet-group"
}

resource "aws_dms_replication_subnet_group" "main" {
  replication_subnet_group_description = "DMS Subnet Group for main vpc and private subnets"
  replication_subnet_group_id          = local.subnet_group_id
  subnet_ids                           = data.aws_subnets.private_subnets.ids

  tags = {
    Name = local.subnet_group_id
  }
}
