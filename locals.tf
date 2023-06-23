locals {
  name            = "aws-efs-csi-driver"
  node_name       = "efs-csi-node"
  controller_name = "efs-csi-controller"
  csi_volume_tags = join(" ", [for key, value in var.tags : "${key}:${value}"])
  prefix          = md5(local.csi_volume_tags)

  labels = merge({
    "app.kubernetes.io/name" = local.name
  }, var.tags, var.labels)
}
