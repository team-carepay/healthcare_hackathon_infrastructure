resource "aws_sagemaker_notebook_instance_lifecycle_configuration" "lc" {
  name     = "disable-download-button"
  on_start = "${base64encode(file("${path.module}/disable_button.sh"))}"
}