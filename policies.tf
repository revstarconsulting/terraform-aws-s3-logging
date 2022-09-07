data "aws_iam_policy_document" "alb" {
  statement {
    sid    = "DenyDeletionOfBucket"
    effect = "Deny"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    actions   = ["s3:DeleteBucket"]
    resources = ["arn:aws:s3:::${var.account_id}-${var.bucket_name}"]
  }
  statement {
    sid    = "AllowAWSLBAccount"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["${data.aws_elb_service_account.this.arn}"]
    }
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::${var.account_id}-${var.bucket_name}/*"]
  }
  statement {
    effect  = "Allow"
    actions = ["s3:PutObject"]
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
    resources = ["arn:aws:s3:::${var.account_id}-${var.bucket_name}/*"]
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }
  statement {
    effect    = "Allow"
    actions   = ["s3:GetBucketAcl"]
    resources = ["arn:aws:s3:::${var.account_id}-${var.bucket_name}"]
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "cloudtrail" {
  statement {
    sid = "AWSCloudTrailAclCheck"
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    actions   = ["s3:GetBucketAcl"]
    resources = ["arn:aws:s3:::${var.account_id}-${var.bucket_name}"]
  }

  statement {
    sid = "AWSCloudTrailWrite"
    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com", "cloudtrail.amazonaws.com"]
    }
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::${var.account_id}-${var.bucket_name}/*"]
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"

      values = [
        "bucket-owner-full-control",
      ]
    }
  }
}

data "aws_iam_policy_document" "cloudfront" {
  statement {
    sid    = "PolicyForCloudFrontPrivateContent"
    effect = "Allow"

    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::${var.account_id}-${var.bucket_name}/*"]

    principals {
      type        = "CanonicalUser"
      identifiers = [var.cdn_canonical_user_id]
    }
  }
}

data "aws_iam_policy_document" "general" {
  statement {
    sid    = "DenyDeletionOfBucket"
    effect = "Deny"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    actions   = ["s3:DeleteBucket"]
    resources = ["arn:aws:s3:::${var.account_id}-${var.bucket_name}"]
  }
  statement {
    effect  = "Allow"
    actions = ["s3:PutObject"]
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
    resources = ["arn:aws:s3:::${var.account_id}-${var.bucket_name}/*"]
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }
  statement {
    effect    = "Allow"
    actions   = ["s3:GetBucketAcl"]
    resources = ["arn:aws:s3:::${var.account_id}-${var.bucket_name}"]
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
  }
}
