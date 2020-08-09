resource "kubernetes_csi_driver" "efs" {
  metadata {
    name = "efs.csi.aws.com"
  }

  spec {
    attach_required   = true
  }
}