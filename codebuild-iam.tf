data "aws_iam_policy_document" "codebuild-policy-document" {
  statement {
    actions = ["s3:*"]
    resources = [
      "${aws_s3_bucket.s3-bucket-backend.arn}/*",
      "${aws_s3_bucket.s3-bucket-backend.arn}",
      join("", [data.aws_s3_bucket.s3-tf-state.arn, "/", "*"]),
      data.aws_s3_bucket.s3-tf-state.arn
    ]
    effect = "Allow"
  }
  statement {
    effect = "Allow"

    actions = [
      "autoscaling:*",
      "cloudwatch:*",
      "codestar-connections:*",
      "codedeploy:*",
      "codepipeline:*",
      "ec2:*",
      "elasticloadbalancing:*",
      "iam:*",
      "kms:*",
      "logs:*",
      "rds:*",
      "s3:*",
      "secretsmanager:*",
      "sns:*"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "codebuild-policy" {
  name   = var.codebuild_policy_name
  path   = "/"
  policy = data.aws_iam_policy_document.codebuild-policy-document.json
}

resource "aws_iam_role" "codebuild-role" {
  name = var.codebuild_role_name

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }        
  ]
}
EOF
}

resource "aws_iam_role_policy" "codebuild-role-policy" {
  name = "codebuild-inline-policy"
  role = aws_iam_role.codebuild-role.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "codebuild:BatchGetProjects"
        ],
        Resource = ["arn:aws:codebuild:ap-south-1:256364431802:project/srmk-infra-vpc-codebuild-project-plan",
        "arn:aws:codebuild:ap-south-1:256364431802:project/srmk-infra-vpc-codebuild-project-apply"]
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "codebuild-policy-attachment1" {
  policy_arn = aws_iam_policy.codebuild-policy.arn
  role       = aws_iam_role.codebuild-role.id
}

resource "aws_iam_role_policy_attachment" "codebuild-policy-attachment2" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonVPCFullAccess"
  role       = aws_iam_role.codebuild-role.id
}