# DMS Module

This Terraform module creates an AWS Database Migration Service (DMS) Replication Subnet Group within a given VPC and attaches the provided subnets. The subnet group is a collection of subnets (typically private) that you can designate for your replication instances.

## Importing module
- When importing module follow the folowing structure
- `envs/<provider>/<env>/<account>/<region>/<service>/<module>`

- example:
-- `envs/aws/dev/sandbox/us-west-1/dms/dms-subnet_group`

## Pre-requisites
- The VPC is already created and tagged appropriately.
- The private subnets are established within this VPC and are tagged to match the filters.
- Subnet Selection: Users must ensure that the selected subnets meet the requirements of the DMS service, such as being in different Availability Zones for high availability if that's needed.

## Argument Reference
The following arguments are supported:

- `env_name` - (Required) The environment name used to construct unique identifiers for resources.
- `tags` - (Optional) A map of tags that are applied to all taggable resources.

### Override Reference (All argurments are optional)
The following arguments are supported and are used to override the names of different resources.
These arguments are recommended to only be used when importing resources into a Terraform module. This helps the transition process by ensuring no resources require redeployment.

- `override_subnet_group_name` - This field overrides the default subnet group name determined by the module.

## Outputs

This module does not have outputs defined.

## Examples
This example shows a basic configuration of the module.
```terraform
module "database_migration_service" {
  source  = "/modules/aws/dms/dms_subnet_group"
  env_name      = "sandbox"
}
```
