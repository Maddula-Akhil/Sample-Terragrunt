variable "bucket_name" {
  type    = string
  default = ""
}

variable "region" {
  type    = string
  default = "us-east-1"
}

provider "aws" {
  region = var.region
}




resource "aws_s3_bucket" "storage_bucket" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_public_access_block" "storage_bucket_access" {
  bucket = aws_s3_bucket.storage_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = false
  restrict_public_buckets = true
}


#resource "aws_s3_bucket" "Static_bucket" {
#  bucket = "static-host-bucket-promact"
#
#  website {
#    index_document = "index.html"
#    error_document = "error.html"
#  }
#
#  tags = {
#    Name = "Static site hosting Bucket"
#  }
#
#  # Add a bucket policy to allow public access
#  policy = <<POLICY
#{
#  "Version": "2012-10-17",
#  "Statement": [
#    {
#      "Effect": "Allow",
#      "Principal": "*",
#      "Action": [
#        "s3:GetObject"
#      ],
#      "Resource": [
#        "arn:aws:s3:::static-host-bucket-promact/*"
#      ]
#    }
#  ]
#}
#POLICY
#}
#
#resource "aws_s3_bucket_object" "index_file" {
#  bucket = aws_s3_bucket.Static_bucket.id
#  key    = "index.html"
#  #source       = "/home/akhil/files/index.html"
#  content_type = "text/html"
#}
#
#resource "aws_s3_bucket_object" "error_file" {
#  bucket = aws_s3_bucket.Static_bucket.id
#  key    = "error.html"
#  #source       = "/home/akhil/files/error.html"
#  content_type = "text/html"
#}
#
#
#
## Define the CloudFront distribution
#resource "aws_cloudfront_distribution" "static_website_distribution" {
#  origin {
#    domain_name = aws_s3_bucket.Static_bucket.website_endpoint
#    origin_id   = "static-host-bucket-promact"
#  }
#  
#  enabled             = true
#  is_ipv6_enabled     = true
#  comment             = "Static website distribution"
#  default_root_object = "index.html"
#  
#  default_cache_behavior {
#    allowed_methods  = ["GET", "HEAD"]
#    cached_methods   = ["GET", "HEAD"]
#    target_origin_id = "static-host-bucket-promact"
#    
#    forwarded_values {
#      query_string = false
#      
#      cookies {
#        forward = "none"
#      }
#    }
#    
#    viewer_protocol_policy = "redirect-to-https"
#    min_ttl                = 0
#    default_ttl           = 86400
#    max_ttl                = 31536000
#  }
#  
#  viewer_certificate {
#    cloudfront_default_certificate = true
#  }
#  
#  restrictions {
#    geo_restriction {
#      restriction_type = "none"
#    }
#  }
#  
#  tags = {
#    Name = "static-host-bucket-promact-distribution"
#  }
#}
#
#
