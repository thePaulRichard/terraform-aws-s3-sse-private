provider "aws" {
  region = "us-east-1"
  #profile = "aws-dev"

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
  source = "../"
  sse    = "kms"
}