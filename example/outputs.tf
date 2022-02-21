output "s3_bucket_id" {
  description = "The name of the bucket."
  value       = module.s3_bucket.s3_bucket_id
}

output "s3_bucket_arn" {
  description = "The ARN of the bucket. Will be of format arn:aws:s3:::bucketname."
  value       = module.s3_bucket.s3_bucket_arn
}

output "kms_key_arn" {
  description = "The Amazon Resource Name (ARN) of the key."
  value       = module.s3_bucket.kms_key_arn
}

output "kms_key_alias_arn" {
  description = "The Amazon Resource Name (ARN) of the key alias."
  value       = module.s3_bucket.kms_key_alias_arn
}
