terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.47"
    }
  }
}


provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}