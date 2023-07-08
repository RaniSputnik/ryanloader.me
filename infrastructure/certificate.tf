provider "aws" {
  alias  = "acm"
  region = "us-east-1"
}

data "aws_acm_certificate" "primary_zone" {
  provider    = aws.acm
  domain      = var.primary_zone
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}
