# DMS Certificate Module

This Terraform module creates a AWS DMS Certificates that can be used by DMS endpoints to support SSL.

## Importing module
- When importing module follow the folowing structure
- `envs/<provider>/<env>/<account>/<region>/<service>/<module>`

- example:
- `envs/aws/dev/sandbox/us-west-1/dms/dms-certificate`

## Pre-requisites
- Certificates need to be acquired for the appropriate engine type. Once acquired they should be incldued in the same folder as the main.tf.

## Argument Reference
The following arguments are supported:

- `aws_env_name` - (Required) AWS Account Environment Name, which might be used for setting up provider configurations or for distinguishing resources in multi-account setups.
- `oracle_cert_filename` - (Optional) Name of the file to use for the Oracle certificate.
- `postgres_cert_filename` - (Optional) Name of the file to use for the Postgres certificate.

## Examples
This example shows a basic configuration of the module.
```terraform
module "dms-certs" {
  # source = "/modules/aws/dms/dms_certificate"
  source = "/modules/aws/dms/dms_certificate"

  aws_env_name           = "Sandbox"
  oracle_cert_filename   = "cwallet.sso"
  postgres_cert_filename = "rds-ca-2019-root.pem"
}

```
