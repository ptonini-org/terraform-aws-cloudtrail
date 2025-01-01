module "bucket" {
  source  = "app.terraform.io/ptonini-org/s3-bucket/aws"
  version = "~> 1.0.0"
  name    = var.bucket_name
  server_side_encryption = {
    kms_master_key_id = var.bucket_kms_key_id
  }
  bucket_policy_statements = [
    {
      Sid    = "AWSCloudTrailAclCheck"
      Effect = "Allow"
      Principal = {
        Service = "cloudtrail.amazonaws.com"
      }
      Action   = "s3:GetBucketAcl"
      Resource = "arn:aws:s3:::${var.bucket_name}"
    },
    {
      Sid    = "AWSCloudTrailWrite"
      Effect = "Allow"
      Principal = {
        Service = "cloudtrail.amazonaws.com"
      }
      Action   = "s3:PutObject"
      Resource = "arn:aws:s3:::${var.bucket_name}/AWSLogs/${var.account_id}/*"
      Condition = {
        StringEquals = {
          "s3:x-amz-acl" = "bucket-owner-full-control"
        }
      }
    }
  ]
  force_destroy = var.force_destroy_bucket
}

resource "aws_cloudtrail" "this" {
  name                          = var.name
  s3_bucket_name                = module.bucket.this.id
  include_global_service_events = var.include_global_service_events
  is_multi_region_trail         = var.is_multi_region_trail
  tags                          = var.tags

  lifecycle {
    ignore_changes = [
      tags["business_unit"],
      tags["product"],
      tags["env"],
      tags_all
    ]
  }
}