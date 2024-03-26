locals {
  create_oracle_cert   = var.oracle_cert_filename != ""
  create_postgres_cert = var.postgres_cert_filename != ""
}

resource "aws_dms_certificate" "rds-ca-certificate" {
  count           = local.create_postgres_cert ? 1 : 0
  certificate_id  = "rds-ca-2019"
  certificate_pem = data.local_sensitive_file.rds-postgres-ca-cert[0].content

  tags = {
    Name = "rds-ca-2019"
  }
}

resource "aws_dms_certificate" "rds-ca-oracle-wallet" {
  count              = local.create_oracle_cert ? 1 : 0
  certificate_id     = "rds-ca-wallet-2019"
  certificate_wallet = data.local_sensitive_file.rds-oracle-wallet[0].content_base64

  tags = {
    Name = "rds-ca-wallet-2019"
  }
}
