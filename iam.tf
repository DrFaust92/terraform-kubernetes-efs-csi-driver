data "aws_iam_policy_document" "efs_controller_policy_doc" {
  count = var.create_controller ? 1 : 0

  statement {
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "elasticfilesystem:DescribeAccessPoints",
      "elasticfilesystem:DescribeFileSystems"
    ]
  }

  statement {
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "elasticfilesystem:CreateAccessPoint"
    ]

    condition {
      test     = "StringLike"
      variable = "aws:RequestTag/efs.csi.aws.com/cluster"
      values = [
        "true"
      ]
    }
  }

  statement {
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "elasticfilesystem:DeleteAccessPoint"
    ]

    condition {
      test     = "StringLike"
      variable = "aws:ResourceTag/efs.csi.aws.com/cluster"
      values = [
        "true"
      ]
    }
  }
}

resource "aws_iam_policy" "efs_controller_policy" {
  count = var.create_controller ? 1 : 0

  name_prefix = var.efs_csi_controller_role_policy_name_prefix
  policy      = data.aws_iam_policy_document.efs_controller_policy_doc[0].json
  tags        = var.tags
}

module "efs_controller_role" {
  count = var.create_controller ? 1 : 0

  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "4.17.0"
  create_role                   = true
  role_description              = "EFS CSI Driver Role"
  role_name_prefix              = var.efs_csi_controller_role_name
  provider_url                  = var.oidc_url
  role_policy_arns              = [aws_iam_policy.efs_controller_policy[0].arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:${var.namespace}:${local.controller_name}"]
  tags                          = var.tags
}