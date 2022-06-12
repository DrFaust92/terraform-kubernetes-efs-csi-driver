output "efs_csi_driver_name" {
  description = "The Name of the EBS CSI driver"
  value       = kubernetes_csi_driver_v1.efs.metadata[0].name
}

output "efs_csi_driver_controller_role_arn" {
  description = "The Name of the EBS CSI driver controller IAM role ARN"
  value       = module.efs_controller_role[0].iam_role_arn
}

output "efs-csi_driver_controller_role_name" {
  description = "The Name of the EBS CSI driver controller IAM role name"
  value       = module.efs_controller_role[0].iam_role_name
}

output "efs_csi_driver_controller_role_policy_arn" {
  description = "The Name of the EBS CSI driver controller IAM role policy ARN"
  value       = aws_iam_policy.efs_controller_policy[0].arn
}

output "efs_csi_driver_controller_role_policy_name" {
  description = "The Name of the EBS CSI driver controller IAM role policy name"
  value       = aws_iam_policy.efs_controller_policy[0].name
}