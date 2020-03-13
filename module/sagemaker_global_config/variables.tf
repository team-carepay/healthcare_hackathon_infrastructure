variable "bucket_arn" {
  type        = string
  description = "ARN for the hackathon data bucket"
}

variable "repo_arn" {
  type        = string
  description = "ARN for the hackathon CodeCommit repository"
}

variable "repo_url" {
  type        = string
  description = "URL for the hackathon CodeCommit repository"
}
