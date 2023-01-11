resource "aws_s3_bucket" "bucket" {
  bucket = "${var.bucket-name}-${random_string.random.result}"
  acl    = var.bucket-acl
}

resource "random_string" "random" {
  length           = 4
  upper            = false
  lower            = true
  numeric           = false
  special          = false
  override_special = "/@£$"
}
