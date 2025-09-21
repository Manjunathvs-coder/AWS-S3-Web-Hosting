resource "aws_s3_bucket" "aws-s3" {
  bucket = var.s3-bucket

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.aws-s3.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_ownership_controls" "owner_control" {
  bucket = aws_s3_bucket.aws-s3.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}


resource "aws_s3_bucket_acl" "acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.owner_control,
    aws_s3_bucket_public_access_block.public_access,
  ]

  bucket = aws_s3_bucket.aws-s3.id
  acl    = "public-read"
}

resource "aws_s3_bucket_policy" "public_policy" {
  bucket = aws_s3_bucket.aws-s3.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = ["s3:GetObject"]
        Resource  = "${aws_s3_bucket.aws-s3.arn}/*"
      }
    ]
  })
}


resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.aws-s3.id
  key          = "index.html"
  source       = "index.html"
  content_type = "text/html"
  acl          = "public-read"
}

resource "aws_s3_object" "error" {
  bucket       = aws_s3_bucket.aws-s3.id
  key          = "error.html"
  source       = "error.html"
  content_type = "text/html"
  acl          = "public-read"
}

resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.aws-s3.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}
