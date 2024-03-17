data "aws_kms_key" "s3_bucket_kms_key" {
  key_id = var.kms_key_alias
}

resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.bucket_name

  tags = var.tags
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_bucket_encryption" {
  count = var.use_aes256 ? 0 : 1

  bucket = aws_s3_bucket.s3_bucket.bucket


  rule {

    bucket_key_enabled = var.bucket_key_enabled

    apply_server_side_encryption_by_default {
      kms_master_key_id = data.aws_kms_key.s3_bucket_kms_key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_bucket_aes_encryption" {
  count = var.use_aes256 ? 1 : 0

  bucket = aws_s3_bucket.s3_bucket.bucket

  rule {
    bucket_key_enabled = var.bucket_key_enabled
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "s3_bucket_versioning" {
  bucket = aws_s3_bucket.s3_bucket.id
  versioning_configuration {
    status = var.enable_versioning ? "Enabled" : "Disabled"
  }
}

# resource "aws_s3_bucket_acl" "s3_bucket_acl" {
#   bucket = aws_s3_bucket.s3_bucket.id
#   acl    = "private"
# }

resource "aws_s3_bucket_public_access_block" "s3_bucket_public_access" {
  bucket = aws_s3_bucket.s3_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
