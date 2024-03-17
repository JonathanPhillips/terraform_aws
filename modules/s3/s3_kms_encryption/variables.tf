variable "bucket_name" {
  type        = string
  description = "The name of the bucket to be created/managed"
  nullable    = false
}

variable "kms_key_alias" {
  type        = string
  description = "KMS Key alias in the format of 'alias/my_key'"
  nullable    = false
}


variable "enable_versioning" {
  type        = bool
  description = "Enable bucket versioning or not. Default is 'true'"
  default     = true
}

variable "tags" {
  description = "Tags to set on the bucket."
  type        = map(string)
  default     = {}
}

variable "use_aes256" {
  type        = bool
  description = "Use AES256 encryption instead of KMS Key Encryption (hack to workaround data.aws_kms_key error)"
  default     = false
}

variable "bucket_key_enabled" {
  type        = bool
  description = "When using KMS key, whether to enable bucket key or not."
  default     = false
}
