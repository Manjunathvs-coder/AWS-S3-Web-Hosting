terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.14.0"
    }
  }
  backend "s3" {
    bucket = "terraform-backend-0509"
    key    = "s3/terraform.tfstate"
    region = "ap-southeast-1"
  }
}
provider "aws" {
  region = "ap-southeast-1"
}
