data "aws_identitystore_group" "sso_group" {
  identity_store_id = var.identity_store_id

  filter {
      attribute_path  = "DisplayName"
      attribute_value = var.azure_group_name
  }
}

resource "aws_ssoadmin_account_assignment" "associate_account" {
  instance_arn       = var.instance_arn
  permission_set_arn = var.permission_set_arn

  principal_id   = data.aws_identitystore_group.sso_group.group_id
  principal_type = "GROUP"

  target_id   = var.aws_account_id
  target_type = "AWS_ACCOUNT"
