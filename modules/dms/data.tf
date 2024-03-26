data "local_sensitive_file" "rds-postgres-ca-cert" {
  count    = local.create_postgres_cert ? 1 : 0
  filename = "${path.root}/${var.postgres_cert_filename}"
}

data "local_sensitive_file" "rds-oracle-wallet" {
  count    = local.create_oracle_cert ? 1 : 0
  filename = "${path.root}/${var.oracle_cert_filename}"
}
