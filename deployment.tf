resource "kubernetes_deployment" "efs_csi_controller" {
  metadata {
    name      = local.controller_name
    namespace = var.namespace
    labels = merge({
      app = local.controller_name
    }, local.labels)
  }

  spec {
    replicas = var.csi_controller_replica_count

    selector {
      match_labels = {
        app                      = local.controller_name
        "app.kubernetes.io/name" = local.name
      }
    }

    template {
      metadata {
        labels = {
          app                      = local.controller_name
          "app.kubernetes.io/name" = local.name
        }
      }

      spec {
        topology_spread_constraint {
          max_skew           = 1
          topology_key       = "kubernetes.io/hostname"
          when_unsatisfiable = "DoNotSchedule"
          label_selector {
            match_labels = {
              app = local.controller_name
            }
          }
        }

        node_selector = var.node_selector

        volume {
          name = "socket-dir"
          empty_dir {}
        }

        container {
          name  = "efs-plugin"
          image = "amazon/aws-efs-csi-driver:${var.driver_release}"
          args = [
            "--endpoint=$(CSI_ENDPOINT)",
            "--logtostderr",
            "--v=${tostring(var.log_level)}",
            length(local.csi_volume_tags) > 0 ? "--tags=${local.csi_volume_tags}" : "",
            "--delete-access-point-root-dir=${var.delete_access_point_root_dir}",
          ]

          port {
            name           = "healthz"
            container_port = 9909
            protocol       = "TCP"
          }

          env {
            name  = "CSI_ENDPOINT"
            value = "unix:///var/lib/csi/sockets/pluginproxy/csi.sock"
          }

          env {
            name = "CSI_NODE_NAME"

            value_from {
              field_ref {
                field_path = "spec.nodeName"
              }
            }
          }

          volume_mount {
            name       = "socket-dir"
            mount_path = "/var/lib/csi/sockets/pluginproxy/"
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

          image_pull_policy = "IfNotPresent"

          security_context {
            privileged = true
          }
        }

        container {
          name  = "csi-provisioner"
          image = "public.ecr.aws/eks-distro/kubernetes-csi/external-provisioner:v3.3.0-eks-1-25-latest"
          args = [
            "--csi-address=$(ADDRESS)",
            "--v=${tostring(var.log_level)}",
            "--feature-gates=Topology=true",
            "--extra-create-metadata",
            "--leader-election",
          ]

          env {
            name  = "ADDRESS"
            value = "/var/lib/csi/sockets/pluginproxy/csi.sock"
          }

          volume_mount {
            name       = "socket-dir"
            mount_path = "/var/lib/csi/sockets/pluginproxy/"
          }

          image_pull_policy = "IfNotPresent"
        }

        container {
          name  = "liveness-probe"
          image = "public.ecr.aws/eks-distro/kubernetes-csi/livenessprobe:v2.8.0-eks-1-25-latest"
          args = [
            "--csi-address=/csi/csi.sock",
            "--health-port=9909"
          ]

          volume_mount {
            name       = "socket-dir"
            mount_path = "/csi"
          }

          image_pull_policy = "IfNotPresent"
        }

        service_account_name = local.controller_name
        priority_class_name  = "system-cluster-critical"
      }
    }
  }
}
