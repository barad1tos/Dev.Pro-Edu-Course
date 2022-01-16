terraform {
  backend "s3" {
    bucket = "dev.pro-test-bucket"
    key    = "test/terraform.tfstate"
    region = "us-east-2"
  }
}