variable "force_destroy" {
  description = "A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable."
  type        = bool
  default     = false
}

variable "versioning" {
  description = "Wether to use versioning in the bucket."
  type        = string
  default     = "Suspended"
}

variable "lifecycle_rule" {
  description = "List of maps containing configuration of object lifecycle management."
  type        = any
  default     = []
}

variable "sse" {
  description = "Sets the Server-side encryption configuration. Can be s3 or kms"
  type        = string
  default     = "s3"
}