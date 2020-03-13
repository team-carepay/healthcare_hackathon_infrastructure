resource "aws_s3_bucket" "hackathon_bucket" {
  bucket_prefix = "hackathon-data"
  acl           = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket_public_access_block" "hackathon_bucket_access_rules" {
  bucket = aws_s3_bucket.hackathon_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
