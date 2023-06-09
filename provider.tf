terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.61.0"
    }
  }

  cloud {
    organization = "gozain-lab"
    workspaces {
      name = "aws_ec2_strongswan"
    }
  }

  required_version = ">= 0.12.9, != 0.13.0"
}

provider "aws" {
  region = var.aws_region
}

