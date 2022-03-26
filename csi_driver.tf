resource "kubernetes_csi_driver" "efs" {
  metadata {
    name   = "efs.csi.aws.com"
    labels = local.labels
  }

  spec {
    attach_required = true
  }
}