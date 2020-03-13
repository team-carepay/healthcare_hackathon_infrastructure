data "aws_iam_policy_document" "sagemaker_signed_url_policy_template" {
  statement {
    sid = "AllowAccessToSageMakerInstance"

    actions = [
      "sagemaker:CreatePresignedNotebookInstanceUrl"
    ]

    resources = [
      "arn:aws:sagemaker:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:notebook-instance/${var.instance_name}"
    ]
  }

  statement {
    sid    = "DenyAccessOutsideOfOfficeIp"
    effect = "Deny"

    actions = [
      "sagemaker:CreatePresignedNotebookInstanceUrl"
    ]

    resources = [
      "*"
    ]
    condition {
      test     = "NotIpAddress"
      variable = "aws:SourceIp"
      values = [
        var.ip
      ]
    }
  }
}


resource "aws_iam_user" "sagemaker_signed_url_signer" {
  name = "sagemaker-signed-url-signer-${var.instance_name}"
}

resource "aws_iam_access_key" "sagemaker_signed_url_signer" {
  user = aws_iam_user.sagemaker_signed_url_signer.name
}

resource "aws_iam_user_policy" "sagemaker_signed_url_signer" {
  name = "sagemaker-signed-url-signer-${var.instance_name}-policy"
  user = aws_iam_user.sagemaker_signed_url_signer.name

  policy = data.aws_iam_policy_document.sagemaker_signed_url_policy_template.json
}
