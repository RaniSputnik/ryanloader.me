terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.7.0"
    }
  }

  required_version = "1.5.2"

  backend "s3" {
    bucket         = "terraform-state-eu-west-1-024281370339"
    key            = "ryanloader.me/dns"
    dynamodb_table = "terraform-lock"
    encrypt        = true
    region         = "eu-west-1"
  }
}

provider "aws" {
  region = "eu-west-1"
  default_tags { tags = local.tags }
}

provider "aws" {
  alias  = "acm"
  region = "us-east-1"
  default_tags { tags = local.tags }
}

provider "aws" {
  alias  = "nz_legacy"
  region = "ap-southeast-2"
  default_tags { tags = local.tags }
}

locals {
  tags = {
    Repository = var.repository
    CreatedBy  = "Terraform"
    Workload   = "Public Website"
  }
}
