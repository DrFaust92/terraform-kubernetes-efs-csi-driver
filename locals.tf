locals {
  name            = "efs-csi-node"
  controller_name = "efs-csi-controller"
  csi_volume_tags = join(",", [for key, value in var.tags : "${key}=${value}"])

  labels = {
    app                      = local.name
    "app.kubernetes.io/name" = "aws-efs-csi-driver"
  }
}