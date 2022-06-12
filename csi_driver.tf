resource "kubernetes_csi_driver_v1" "efs" {
  metadata {
    name   = "efs.csi.aws.com"
    labels = local.labels
  }

  spec {
    attach_required = true
  }
}