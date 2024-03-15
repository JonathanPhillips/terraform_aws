resource "aws_transfer_server" "sftp_server" {
  identity_provider_type = "SERVICE_MANAGED"
  protocols              = ["SFTP"]

  endpoint_type = "PUBLIC" # default
  security_policy_name = "TransferSecurityPolicy-2024-01"

  logging_role = aws_iam_role.logging_role.arn # IAM role for logging

  tags = {
    Name = "SFTPTransferServer-JP"
  }
}

resource "aws_iam_role" "logging_role" {
  name = "sftp-transfer-logging-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "transfer.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "logging_policy" {
  name        = "sftp-transfer-logging-policy"
  description = "A logging policy for TF transfer"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:DeleteObject",
        "s3:DeleteObjectVersion"
      ],
      "Resource": "arn:aws:s3:::your-s3-bucket-name/*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "logging_policy_attach" {
  role       = aws_iam_role.logging_role.name
  policy_arn = aws_iam_policy.logging_policy.arn
}
