provider "aws" {
  region = "us-east-1"
}

terraform {
  required_version = ">= 1.3"
  backend "s3" {
    bucket         = "terraform-backend-softserve"
    key            = "terraform/demo_3/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-backend-softserve"
    session_name   = "terraform"
  }
}