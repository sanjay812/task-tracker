resource "random_id" "bucket_suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "this" {
  bucket               = "${var.bucket_name_prefix}-${random_id.bucket_suffix.hex}"
  aws_s3_bucket_acl    = "private"

  tags = var.tags
}
