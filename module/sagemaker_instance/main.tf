resource "null_resource" "sagemaker_instance_default_repository" {
  provisioner "local-exec" {
    command = "aws sagemaker create-notebook-instance --notebook-instance-name ${var.instance_name} --instance-type ${var.instance_type} --role-arn ${var.sagemaker_role_arn} --default-code-repository hackathon-repository --lifecycle-config-name disable-download-button --tags Key=Owner,Key=Project,Value=HackathonInfra"
  }

  provisioner "local-exec" {
    when    = "destroy"
    command = "aws sagemaker delete-notebook-instance --notebook-instance-name ${var.instance_name} "
  }
}