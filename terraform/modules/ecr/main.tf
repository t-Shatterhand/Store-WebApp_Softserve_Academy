data "aws_caller_identity" "current" {}

resource "aws_ecrpublic_repository" "ecr" {
  repository_name = "ecr-demo-3"

  tags = merge(var.tags, { "Name" = "ecr-demo-3" })
}

data "aws_iam_policy_document" "ecr" {
  statement {
    sid    = "ECR policy"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [data.aws_caller_identity.current.account_id]
    }

    actions = [
      "ecr-public:GetAuthorizationToken",
      "ecr-public:GetDownloadUrlForLayer",
      "ecr-public:BatchGetImage",
      "ecr-public:BatchCheckLayerAvailability",
      "ecr-public:PutImage",
      "ecr-public:InitiateLayerUpload",
      "ecr-public:UploadLayerPart",
      "ecr-public:CompleteLayerUpload",
      "ecr-public:DescribeRepositories",
      "ecr-public:GetRepositoryPolicy",
      "ecr-public:ListImages",
      "ecr-public:DeleteRepository",
      "ecr-public:BatchDeleteImage",
      "ecr-public:SetRepositoryPolicy",
      "ecr-public:DeleteRepositoryPolicy",
    ]
  }
}
resource "aws_ecrpublic_repository_policy" "ecr" {
  repository_name = aws_ecrpublic_repository.ecr.repository_name
  policy          = data.aws_iam_policy_document.ecr.json
}