variable "environment" {
  description = "The environment"
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

locals {
  common_tags = {
    environment = var.environment
  }
}
