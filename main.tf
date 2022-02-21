terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}

data "aws_default_tags" "this" {}

resource "random_id" "this" {
  byte_length = 8
}

locals {
  rem_spaces = lower(replace(data.aws_default_tags.this.tags.Name, " ", ""))
  bucket     = "${local.rem_spaces}-${random_id.this.hex}"
}

resource "aws_kms_key" "s3" {
  count = contains([var.sse], "kms") ? 1 : 0

  description = "This key is used to encrypt the bucket ${local.bucket}"
}

resource "aws_kms_alias" "s3" {
  count = contains([var.sse], "kms") ? 1 : 0

  name          = "alias/${local.bucket}"
  target_key_id = element(aws_kms_key.s3.*.key_id, count.index)
}

resource "aws_s3_bucket" "private" {
  bucket        = local.bucket
  force_destroy = var.force_destroy
}

resource "aws_s3_bucket_acl" "this" {
  bucket = aws_s3_bucket.private.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.private.id

  versioning_configuration {
    status = var.versioning
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3" {
  count = contains([var.sse], "s3") ? 1 : 0

  bucket = aws_s3_bucket.private.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "kms" {
  count = contains([var.sse], "kms") ? 1 : 0

  bucket = aws_s3_bucket.private.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = element(aws_kms_key.s3.*.arn, count.index)
      sse_algorithm     = "aws:kms"
    }
  }
}

# Block public acess
resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.private.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Allow CloudFront access and deny unencrypted objects
resource "aws_s3_bucket_policy" "sse_s3" {
  count = contains([var.sse], "s3") ? 1 : 0

  bucket = aws_s3_bucket.private.id
  policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Sid       = "DenyIncorrectEncryptionHeader"
          Action    = "s3:PutObject"
          Effect    = "Deny"
          Resource  = "${aws_s3_bucket.private.arn}/*"
          Principal = "*"
          Condition = {
            StringNotEquals = {
              "s3:x-amz-server-side-encryption" = "AES256"
            }
          }
        },
        {
          Sid       = "DenyUnencryptedObjectUploads"
          Effect    = "Deny"
          Action    = "s3:PutObject"
          Resource  = "${aws_s3_bucket.private.arn}/*"
          Principal = "*"
          Condition = {
            Null = {
              "s3:x-amz-server-side-encryption" = "true"
            }
          }
        },
      ]
    }
  )
}

resource "aws_s3_bucket_policy" "sse_kms" {
  count = contains([var.sse], "kms") ? 1 : 0

  bucket = aws_s3_bucket.private.id
  policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Sid       = "DenyIncorrectEncryptionHeader"
          Action    = "s3:PutObject"
          Effect    = "Deny"
          Resource  = "${aws_s3_bucket.private.arn}/*"
          Principal = "*"
          Condition = {
            StringNotEquals = {
              "s3:x-amz-server-side-encryption" = "aws:kms"
            }
          }
        },
      ]
    }
  )
}
