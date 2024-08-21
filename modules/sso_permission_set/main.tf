data "aws_ssoadmin_instances" "azure" {}

resource "aws_ssoadmin_permission_set" "permission" {
  name             = var.name
  description      = var.description
  instance_arn     = tolist(data.aws_ssoadmin_instances.azure.arns)[0]
  session_duration = var.session_duration

  tags = merge(var.tags, {
    Name = var.name
  })
}

resource "aws_ssoadmin_permission_set_inline_policy" "permission_policy" {
  count = "${var.inline_policy != "" ? 1 : 0}"

  inline_policy      = var.inline_policy
  instance_arn       = aws_ssoadmin_permission_set.permission.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.permission.arn
}

module "permission_set_association" {
  source = "../sso_permission_set_association"

  for_each = { for association in var.associations : ("${association.aws_account_id}-${association.azure_group_name}") => association }

  permission_set_arn = aws_ssoadmin_permission_set.permission.arn
  instance_arn       = aws_ssoadmin_permission_set.permission.instance_arn
  identity_store_id  = tolist(data.aws_ssoadmin_instances.azure.identity_store_ids)[0]

  aws_account_id   = each.value.aws_account_id
  azure_group_name = each.value.azure_group_name
}

resource "aws_ssoadmin_managed_policy_attachment" "managed" {
  for_each = { for policy in var.managed_policies : policy => policy }

  instance_arn       = aws_ssoadmin_permission_set.permission.instance_arn
  managed_policy_arn = each.value
  permission_set_arn = aws_ssoadmin_permission_set.permission.arn
}

resource "aws_ssoadmin_customer_managed_policy_attachment" "customer_managed" {
  for_each = { for policy in var.customer_managed_policies : policy => policy }

  instance_arn       = aws_ssoadmin_permission_set.permission.instance_arn
  customer_managed_policy_reference {
    name = each.key
    path = "/"
  }
  permission_set_arn = aws_ssoadmin_permission_set.permission.arn
}
