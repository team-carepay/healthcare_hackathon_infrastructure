output "bucket_arn" {
  value = aws_s3_bucket.hackathon_bucket.arn
}

output "access_key" {
  value = aws_iam_access_key.hackathon_data_uploader.id
}

output "secret_access_key" {
  value = aws_iam_access_key.hackathon_data_uploader.secret
}