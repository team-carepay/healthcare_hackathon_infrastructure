data "aws_iam_policy_document" "sagemaker_policy_template" {
  statement {
    sid = "AllowListInHackathonBucket"

    actions = [
      "s3:ListBucket"
    ]

    resources = [
      var.bucket_arn
    ]
  }

  statement {
    sid = "AllowWriteInHackathonBucket"

    actions = [
      "s3:PutObject",
    ]

    resources = [
      "${var.bucket_arn}/MomCare/Shared/*",
      "${var.bucket_arn}/SafeCare/Shared/*"
    ]
  }

  statement {
    sid = "AllowReadInHackathonBucket"

    actions = [
      "s3:GetObject",
      "s3:HeadObject",
      "s3:GetObjectVersion",
    ]

    resources = [
      "${var.bucket_arn}/*"
    ]
  }

  statement {
    sid    = "DenyAnythingToMaster"
    effect = "Deny"

    actions = [
      "codecommit:GitPush",
      "codecommit:DeleteBranch",
      "codecommit:PutFile",
      "codecommit:MergeBranchesByFastForward",
      "codecommit:MergeBranchesBySquash",
      "codecommit:MergeBranchesByThreeWay",
      "codecommit:MergePullRequestByFastForward",
      "codecommit:MergePullRequestBySquash",
      "codecommit:MergePullRequestByThreeWay"
    ]

    condition {
      test     = "StringEqualsIfExists"
      variable = "codecommit:References"
      values = [
        "refs/heads/master",
      ]
    }

    condition {
      test     = "Null"
      variable = "codecommit:References"
      values   = ["false"]
    }

    resources = [
      "*"
    ]
  }

  statement {
    sid    = "AllowTeamsToManageTheirOwnStuff"
    effect = "Allow"

    actions = [
      "codecommit:GitPull",
      "codecommit:GitPush",
      "codecommit:CreateBranch",
      "codecommit:GetBranch",
      "codecommit:ListBranches",
      "codecommit:CreatePullRequest"
    ]

    resources = [
      var.repo_arn
    ]
  }

}

data "aws_iam_policy_document" "sagemaker_assume_role_policy_template" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["sagemaker.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "sagemaker_role" {
  name               = "sagemaker-hackathon-role"
  assume_role_policy = data.aws_iam_policy_document.sagemaker_assume_role_policy_template.json
}

resource "aws_iam_policy" "sagemaker_policy" {
  name   = "sagemaker-hackathon-policy"
  policy = data.aws_iam_policy_document.sagemaker_policy_template.json
}


resource "aws_iam_policy_attachment" "sagemaker_role_attachment" {
  name       = "sagemaker-hackathon-policy-attachment"
  roles      = [aws_iam_role.sagemaker_role.name]
  policy_arn = aws_iam_policy.sagemaker_policy.arn
}