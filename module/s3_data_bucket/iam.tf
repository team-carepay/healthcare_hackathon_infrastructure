data "aws_iam_policy_document" "s3_upload_policy_template" {
  statement {
    sid = "AllowListInHackathonBucket"

    actions = [
      "s3:ListBucket"
    ]

    resources = [
      aws_s3_bucket.hackathon_bucket.arn
    ]
  }

  statement {
    sid = "AllowWriteInHackathonBucket"

    actions = [
      "s3:PutObject",
    ]

    resources = [
      "${aws_s3_bucket.hackathon_bucket.arn}/*"
    ]
  }
}


resource "aws_iam_user" "hackathon_data_uploader" {
  name = "hackathon-data-uploader"
}

resource "aws_iam_access_key" "hackathon_data_uploader" {
  user = aws_iam_user.hackathon_data_uploader.name
}

resource "aws_iam_user_policy" "hackathon_data_uploader" {
  name = "hackathon-data-uploader-policy"
  user = aws_iam_user.hackathon_data_uploader.name

  policy = data.aws_iam_policy_document.s3_upload_policy_template.json
}
