terraform {
  required_version = ">= 1.3.0"

  backend "s3" {
    bucket         = "kk-terraform-state"
    key            = "global/s3/terraform.tfstate"
    region         = "eu-north-1"
    dynamodb_table = "kk-tf-lock"
    encrypt        = true
  }
}

provider "aws" {
  region = "eu-north-1"
}