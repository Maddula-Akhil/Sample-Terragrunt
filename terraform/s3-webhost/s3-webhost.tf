resource "aws_s3_bucket" "s3-webhost" {
  bucket = local.s3-webhost-bucket-name
}

resource "aws_s3_bucket_acl" "s3-webhost-acl" {
  bucket = aws_s3_bucket.s3-webhost.bucket
  acl    = "public-read"
}

resource "aws_s3_bucket_cors_configuration" "s3-webhost-cors" {
  bucket = aws_s3_bucket.s3-webhost.bucket

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
  }
}

resource "aws_s3_bucket_website_configuration" "s3-webhost-website-config" {
  bucket = aws_s3_bucket.s3-webhost.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

# IAM Policy for S3 frontend bucket
resource "aws_iam_policy" "s3-frontend-deploy-policy" {
  name        = local.s3-webhost-iam-policy

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "s3:*"
        Effect   = "Allow"
        Resource = [
          "${aws_s3_bucket.s3-webhost.arn}",
          "${aws_s3_bucket.s3-webhost.arn}/*"
          ]
      },
    ]
  })
}
