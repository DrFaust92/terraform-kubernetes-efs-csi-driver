resource "aws_iam_policy" "efs_controller_policy" {
  name_prefix = var.efs_csi_controller_role_policy_name_prefix == "" ? local.prefix : var.efs_csi_controller_role_policy_name_prefix
  policy      = file("${path.module}/iam-policy.json")
  tags        = var.tags
}

module "iam_assumable_role_with_oidc" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "~> 5.0"

  create_role                   = true
  role_name_prefix              = var.efs_csi_controller_role_name == "" ? local.prefix : var.efs_csi_controller_role_name
  oidc_fully_qualified_subjects = ["system:serviceaccount:${var.namespace}:${local.controller_name}"]
  provider_url                  = var.oidc_url
  role_policy_arns              = [aws_iam_policy.efs_controller_policy.arn]
  number_of_role_policy_arns    = 1
  tags                          = var.tags
}
