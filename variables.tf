variable "environment" {
  description = "The environment"
}

variable "region" {
  type    = string
  default = ""
}

variable "bucket_name" {
  description = "Bucket name to be created"
}

variable "account_id" {
  description = "AWS Account ID"
}

variable "service" {

}

variable "block_public_acls" {
  description = "Set this variable to false if public access is requested."
  type        = bool
  default     = true
}

variable "block_public_policy" {
  description = "Set this variable to false is public access is requested."
  type        = bool
  default     = true
}

variable "cdn_canonical_user_id" {
  description = "s3 canonical user id"
  type        = string
  default     = ""
}

locals {
  common_tags = {
    environment = var.environment
  }
}
