provider "aws" {

}

module "s3_data_bucket" {
  source = "../../module/s3_data_bucket"
}

output "s3_data_uploader_access_key" {
  value = module.s3_data_bucket.access_key
}

output "s3_data_uploader_secret_access_key" {
  value = module.s3_data_bucket.secret_access_key
}

resource "aws_codecommit_repository" "hackathon_repository" {
  repository_name = "hackathon-repository"
  description     = "This is the main repository for hosting hackathon related code"
  default_branch  = "master"
}

output "git_repo_id" {
  value = aws_codecommit_repository.hackathon_repository.repository_id
}

output "git_repo_arn" {
  value = aws_codecommit_repository.hackathon_repository.arn
}

module "global_config" {
  source = "../../module/sagemaker_global_config"

  bucket_arn = module.s3_data_bucket.bucket_arn
  repo_arn   = aws_codecommit_repository.hackathon_repository.arn
  repo_url   = aws_codecommit_repository.hackathon_repository.clone_url_http
}

module "demo_sagemaker_instance" {
  source = "../../module/sagemaker_instance"

  instance_name      = "demo"
  sagemaker_role_arn = module.global_config.arn
  ip                 = "127.255.255.255/32"
}

output "demo_access_key" {
  value = module.sagemaker_instance.access_key
}

output "demo_secret_access_key" {
  value = module.sagemaker_instance.secret_access_key
}