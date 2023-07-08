provider "aws" {
  alias  = "nz_legacy"
  region = "ap-southeast-2"
}

resource "aws_s3_bucket" "assets" {
  provider = aws.nz_legacy
  bucket   = var.primary_zone
}

locals {
  s3_origin_id = "S3-ryanloader.me"
}

resource "aws_cloudfront_origin_access_identity" "assets" {
  comment = "Static content for ryanloader.me"
}

resource "aws_cloudfront_distribution" "public" {
  provider = aws.nz_legacy

  origin {
    # TODO: This should probably be set to regional domain name instead
    domain_name = aws_s3_bucket.assets.bucket_domain_name
    origin_id   = local.s3_origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.assets.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  # TODO: Add logging config

  aliases = [var.primary_zone, "www.${var.primary_zone}"]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    compress               = true
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
  }

  dynamic "custom_error_response" {
    for_each = [403, 404]
    iterator = error_code
    content {
      error_caching_min_ttl = 300
      error_code            = error_code.value
      response_code         = 404
      response_page_path    = "/404.html"
    }
  }

  restrictions {
    geo_restriction {
      locations        = []
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = data.aws_acm_certificate.primary_zone.arn
    minimum_protocol_version = "TLSv1.1_2016"
    ssl_support_method       = "sni-only"
  }
}
