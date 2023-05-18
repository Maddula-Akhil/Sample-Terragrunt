# Variables
variable "private_bucket_1_name" {
  type    = string
  default = "storage-bucket-promact"
  description = "The name of the first private S3 bucket to create."
}

variable "private_bucket_2_name" {
  type    = string
  default = "static-site-bucket-promact"
  description = "The name of the second private S3 bucket to create."
}


# The bucket storage_bucket is connected to CloudFront.

resource "aws_s3_bucket" "storage_bucket" {
  bucket = var.private_bucket_1_name
}

resource "aws_s3_bucket_public_access_block" "storage_bucket_access" {
  bucket = aws_s3_bucket.storage_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = false
  restrict_public_buckets = true
}


# The bucket static_site_bucket is connected to CloudFront.

resource "aws_s3_bucket" "static_site_bucket" {
  bucket = var.private_bucket_2_name
}

resource "aws_s3_bucket_public_access_block" "static_site_bucket_access" {
  bucket = aws_s3_bucket.static_site_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = false
  restrict_public_buckets = true
}


# This cloudfront is connected to storage_bucket.

resource "aws_cloudfront_distribution" "storage_bucket_cloudfront" {
  origin {
    domain_name = aws_s3_bucket.static_site_bucket.bucket_regional_domain_name
    origin_id   = "my-private-bucket"
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "My CloudFront distribution"
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "my-private-bucket"

    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  price_class = "PriceClass_100"

}

