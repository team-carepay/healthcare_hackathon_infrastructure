# Terraform does not support this yet, hence the hacky bash scripts solution
# I am not touching cloud formation
resource "null_resource" "sagemaker_code_repository" {
  provisioner "local-exec" {
    command = "aws sagemaker create-code-repository --code-repository-name hackathon-repository --git-config RepositoryUrl=${var.repo_url},Branch=master"
  }

  provisioner "local-exec" {
    when    = "destroy"
    command = "aws sagemaker delete-code-repository --code-repository-name hackathon-repository"
  }
}
