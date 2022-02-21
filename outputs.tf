output "s3_bucket_id" {
  description = "The name of the bucket."
  value       = element(concat(aws_s3_bucket.private.*.id, [""]), 0)
}

output "s3_bucket_arn" {
  description = "The ARN of the bucket. Will be of format arn:aws:s3:::bucketname."
  value       = element(concat(aws_s3_bucket.private.*.arn, [""]), 0)
}

output "kms_key_arn" {
  description = "The Amazon Resource Name (ARN) of the key."
  value       = element(concat(aws_kms_key.s3.*.arn, [""]), 0)
}

output "kms_key_id" {
  description = "The globally unique identifier for the key."
  value       = element(concat(aws_kms_key.s3.*.id, [""]), 0)
}

output "kms_key_alias_arn" {
  description = "The Amazon Resource Name (ARN) of the key alias."
  value       = element(concat(aws_kms_alias.s3.*.arn, [""]), 0)
}

output "kms_key_alias_name" {
  description = "The display name of the alias."
  value       = element(concat(aws_kms_alias.s3.*.name, [""]), 0)
}