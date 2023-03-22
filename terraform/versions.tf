provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Owner       = var.my_name
      Project     = "Serverless Fault Tolerance POC"
      Provisioner = "Terraform"
    }
  }
}

terraform {
  required_version = "~> 1.3.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}