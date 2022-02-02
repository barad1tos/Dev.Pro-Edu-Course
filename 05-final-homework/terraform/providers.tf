terraform {
  required_providers {
    aws = {
      source   = "hashicorp/aws"
      version  = "~> 3.70.0"
    }
    cloudflare = {
      source   = "cloudflare/cloudflare"
      version  = "~> 3.0"
    }
  }
}

provider "aws" {
  region  = var.aws_region
  profile = "default"
}

provider "cloudflare" {
  email   = var.cloudflare_email
  api_key = var.api_key
}