output "access_key" {
  value = aws_iam_access_key.sagemaker_signed_url_signer.id
}

output "secret_access_key" {
  value = aws_iam_access_key.sagemaker_signed_url_signer.secret
}