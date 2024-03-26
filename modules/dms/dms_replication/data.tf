data "aws_kms_alias" "dms" {
  name = "alias/AWS-KEY-${upper(var.aws_env_name)}-DMS"
}

data "aws_dms_replication_subnet_group" "main" {
  replication_subnet_group_id = (var.override_subnet_group != ""
    ? var.override_subnet_group
  : "${lower(var.aws_env_name)}-subnet-group")
}

data "aws_security_group" "dms_security_group" {
  name = "SG-${upper(var.aws_env_name)}-PRIVATE-DMS"
}

data "aws_iam_role" "dms_service_role" {
  name = (var.override_service_role != ""
    ? var.override_service_role
  : "dmsservicerole")
}

data "aws_secretsmanager_secret" "source_dms_user" {
  name = var.source_username_secretsmanager
}

data "aws_secretsmanager_secret" "target_dms_user" {
  name = var.target_username_secretsmanager
}
