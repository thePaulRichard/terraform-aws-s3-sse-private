# AWS S3 SSE Private
Terraform module which creates a private S3 bucket with SSE (sse-s3/kms).

*The use of **default_tags** inside providers it's **required**, but only **Name** is needed to name the bucket.

## Usage with sse-s3

```hcl
provider "aws" {
  region  = "us-east-1"
  profile = "aws-dev"

  default_tags {
    tags = {
      Name        = "Paul Richard Test"
      Environment = "DEV"
      Owner       = "Paul Richard"
      Project     = "My Project"
    }
  }
}

module "s3_bucket" {
  source = "git@github.com:thePaulRichard/terraform-aws-s3-sse-private.git"
}
```

### Usage with kms

```hcl
provider "aws" {
  region  = "us-east-1"
  profile = "aws-dev"

  default_tags {
    tags = {
      Name        = "Paul Richard Test"
      Environment = "DEV"
      Owner       = "Paul Richard"
      Project     = "My Project"
    }
  }
}

module "s3_bucket" {
  source = "git@github.com:thePaulRichard/terraform-aws-s3-sse-private.git"
  sse    = "kms"
}
```

## Examples

- [Example using KMS](example)

## Inputs

| Name | Description | Type | Default |	Required |
| --- | --- | --- | --- | --- |
| force_destroy | A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable. | `bool` | `false` | no |
| versioning | Wether to use versioning in the bucket. | `string` | `Suspended` | yes |
| lifecycle_rule | List of maps containing configuration of object lifecycle management. | `any` | `null` | no |
| sse | Sets the Server-side encryption configuration. Can be s3 or kms. | `string` | `s3` | yes |

## Outputs

| Name | Description |
| --- | --- |
| s3_bucket_id | The S3 Bucket ID. |
| s3_bucket_arn | The ARN of the bucket. Will be of format arn:aws:s3:::bucketname. |
| kms_key_arn | The Amazon Resource Name (ARN) of the key. |
| kms_key_id | The globally unique identifier for the key. |
| kms_key_alias_arn | The Amazon Resource Name (ARN) of the key alias. |
| kms_key_alias_name | The display name of the alias. |
