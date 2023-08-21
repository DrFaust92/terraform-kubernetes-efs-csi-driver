resource "kubernetes_csi_driver_v1" "efs_csi_aws_com" {
  metadata {
    name   = "efs.csi.aws.com"
    labels = local.labels
  }

  spec {
    attach_required        = false
    volume_lifecycle_modes = ["Persistent"]
  }
}
