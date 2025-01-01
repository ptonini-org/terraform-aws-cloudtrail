variable "name" {}

variable "bucket_name" {}

variable "bucket_kms_key_id" {
  default = null
}

variable "force_destroy_bucket" {
  default = false
  nullable = false
}

variable "include_global_service_events" {
  default = true
  nullable = false
}

variable "is_multi_region_trail" {
  default = false
  nullable = false
}

variable "account_id" {}

variable "tags" {
  type    = map(string)
  default = {}
}