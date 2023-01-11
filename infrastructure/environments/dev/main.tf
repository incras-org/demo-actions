provider "aws" {
  region     = "eu-west-1"
}

module "bucket" {
  source = "../../modules/s3-mod/"
  bucket-name = "mir-wr-demo-today"
  bucket-acl = "private"
}