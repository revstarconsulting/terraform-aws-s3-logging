resource "aws_s3_bucket" "s3_bucket" {
  #tfsec:ignore:AWS002
  bucket = "${var.account_id}-${var.bucket_name}"
  tags   = local.common_tags
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.s3_bucket.id
  versioning_configuration {
    status = "Disabled"
  }
}

# Resource to avoid error "AccessControlListNotSupported The bucket does not allow ACLs"
resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id
  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_acl" "this" {
  bucket = aws_s3_bucket.this.id
  acl    = "log-delivery-write"
  depends_on = [aws_s3_bucket_ownership_controls.this]
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.s3_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
resource "aws_s3_bucket_policy" "alb" {
  count  = var.service == "alb" ? 1 : 0
  bucket = aws_s3_bucket.s3_bucket.id
  policy = data.aws_iam_policy_document.alb.json
}

resource "aws_s3_bucket_policy" "cloudtrail" {
  count  = var.service == "cloudtrail" ? 1 : 0
  bucket = aws_s3_bucket.s3_bucket.id
  policy = data.aws_iam_policy_document.cloudtrail.json
}

resource "aws_s3_bucket_policy" "cloudfront" {
  count  = var.service == "cloudfront" ? 1 : 0
  bucket = aws_s3_bucket.s3_bucket.id
  policy = data.aws_iam_policy_document.cloudfront.json
}

resource "aws_s3_bucket_policy" "general" {
  count  = var.service != "alb" && var.service != "cloudtrail" ? 1 : 0
  bucket = aws_s3_bucket.s3_bucket.id
  policy = data.aws_iam_policy_document.general.json
}

resource "aws_s3_bucket_public_access_block" "s3_bucket_acl" {
  bucket = aws_s3_bucket.s3_bucket.id

  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = true
  restrict_public_buckets = true
}
