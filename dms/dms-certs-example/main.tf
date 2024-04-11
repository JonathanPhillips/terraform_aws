module "dms-certs" {
  source = "../../../modules/dms/dms_certificate
  aws_env_name           = "sandbox"
  postgres_cert_filename = "rds-ca-2019-root.pem"
}
