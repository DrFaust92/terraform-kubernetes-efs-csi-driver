resource "kubernetes_service_account" "csi_controller" {
  metadata {
    name      = local.controller_name
    namespace = var.namespace
    labels    = local.labels
    annotations = {
      "eks.amazonaws.com/role-arn" = module.iam_assumable_role_with_oidc.iam_role_arn
    }
  }
  automount_service_account_token = false
}

resource "kubernetes_secret" "csi_controller" {
  metadata {
    name      = local.controller_name
    namespace = var.namespace
    labels    = local.labels
    annotations = {
      "kubernetes.io/service-account.name"      = local.controller_name
      "kubernetes.io/service-account.namespace" = var.namespace
    }
  }
  type       = "kubernetes.io/service-account-token"
  depends_on = [kubernetes_service_account.csi_controller]
}

resource "kubernetes_service_account" "csi_node" {
  metadata {
    name      = local.node_name
    namespace = var.namespace
    labels    = local.labels
  }
  automount_service_account_token = false
}

resource "kubernetes_secret" "csi_node" {
  metadata {
    name      = local.node_name
    namespace = var.namespace
    labels    = local.labels
    annotations = {
      "kubernetes.io/service-account.name"      = local.node_name
      "kubernetes.io/service-account.namespace" = var.namespace
    }
  }
  type       = "kubernetes.io/service-account-token"
  depends_on = [kubernetes_service_account.csi_node]
}
