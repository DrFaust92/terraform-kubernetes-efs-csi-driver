resource "kubernetes_deployment" "efs_csi_controller" {
  count = var.create_controller ? 1 : 0

  metadata {
    name        = local.controller_name
    namespace   = var.namespace
    labels      = var.labels
    annotations = var.controller_annotations
  }
  spec {
    replicas = var.csi_controller_replica_count

    selector {
      match_labels = {
        app = local.controller_name
      }
    }

    template {
      metadata {
        labels = {
          app = local.controller_name
        }
      }

      spec {
        host_network = true

        node_selector = merge({
          "beta.kubernetes.io/os" : "linux",
        }, var.extra_node_selectors, var.controller_extra_node_selectors)

        service_account_name            = kubernetes_service_account[0].csi_driver.metadata[0].name
        automount_service_account_token = true
        priority_class_name             = "system-cluster-critical"

        toleration {
          operator = "Exists"
        }

        dynamic "toleration" {
          for_each = var.csi_controller_tolerations
          content {
            key                = lookup(toleration.value, "key", null)
            operator           = lookup(toleration.value, "operator", null)
            effect             = lookup(toleration.value, "effect", null)
            value              = lookup(toleration.value, "value", null)
            toleration_seconds = lookup(toleration.value, "toleration_seconds", null)
          }
        }

        container {
          name  = "efs-plugin"
          image = "amazon/aws-efs-csi-driver:v1.2.0"
          args = compact(
            [
              "--endpoint=$(CSI_ENDPOINT)",
              "--logtostderr",
              "--v=${tostring(var.log_level)}",
              length(local.csi_volume_tags) > 0 ? "tags=${local.csi_volume_tags}" : "",
              var.delete_access_point_root_dir != "" ? "--delete-access-point-root-dir==${var.delete_access_point_root_dir}" : ""
            ]
          )

          env {
            name  = "CSI_ENDPOINT"
            value = "unix:///var/lib/csi/sockets/pluginproxy/csi.sock"
          }

          volume_mount {
            mount_path = "/var/lib/csi/sockets/pluginproxy/"
            name       = "socket-dir"
          }

          port {
            name           = "healthz"
            container_port = 9808
            protocol       = "TCP"
          }

          liveness_probe {
            http_get {
              path = "/healthz"
              port = "healthz"
            }

            initial_delay_seconds = 10
            timeout_seconds       = 3
            period_seconds        = 10
            failure_threshold     = 5
          }

          readiness_probe {
            http_get {
              path = "/healthz"
              port = "healthz"
            }

            initial_delay_seconds = 10
            timeout_seconds       = 3
            period_seconds        = 10
            failure_threshold     = 5
          }

          security_context {
            privileged = true
          }
        }

        container {
          name  = "csi-provisioner"
          image = "public.ecr.aws/eks-distro/kubernetes-csi/external-provisioner:v2.1.1-eks-1-18-2"
          args = compact(
            [
              "--csi-address=$(ADDRESS)",
              "--v=${tostring(var.log_level)}",
              "--feature-gates=Topology=true",
              "--leader-election",
            ]
          )

          env {
            name  = "ADDRESS"
            value = "/var/lib/csi/sockets/pluginproxy/csi.sock"
          }

          volume_mount {
            mount_path = "/var/lib/csi/sockets/pluginproxy/"
            name       = "socket-dir"
          }
        }

        container {
          name  = "liveness-probe"
          image = "public.ecr.aws/eks-distro/kubernetes-csi/livenessprobe:v2.2.0-eks-1-18-2"
          args = [
            "--csi-address=/csi/csi.sock",
            "--health-port=9808"
          ]

          volume_mount {
            mount_path = "/csi"
            name       = "socket-dir"
          }
        }

        volume {
          name = "socket-dir"
          empty_dir {}
        }
      }
    }
  }

  depends_on = [
    kubernetes_cluster_role_binding.provisioner,
    kubernetes_csi_driver.efs,
  ]
}
