variable "instance_name" {
  type        = string
  description = "Name of the sagemaker instance"
}

variable "instance_type" {
  type        = string
  description = "Type of the sagemaker instance"
  default     = "ml.t2.xlarge"
}


variable "sagemaker_role_arn" {
  type        = string
  description = "ARN of the sagemaker role"
}

variable "ip" {
  type        = string
  description = "Allow blocking of access to SageMaker only from an IP"
}
