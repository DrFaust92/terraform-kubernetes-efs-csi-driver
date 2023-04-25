resource "kubernetes_daemonset" "efs_csi_node" {
  metadata {
    name      = local.node_name
    namespace = var.namespace

    labels = merge({
      app = local.node_name
    }, local.labels)
  }

  spec {
    selector {
      match_labels = {
        app                      = local.node_name
        "app.kubernetes.io/name" = local.name
      }
    }

    template {
      metadata {
        labels = {
          app                      = local.node_name
          "app.kubernetes.io/name" = local.name
        }
      }

      spec {
        volume {
          name = "kubelet-dir"

          host_path {
            path = "/var/lib/kubelet"
            type = "Directory"
          }
        }

        volume {
          name = "plugin-dir"

          host_path {
            path = "/var/lib/kubelet/plugins/efs.csi.aws.com/"
            type = "DirectoryOrCreate"
          }
        }

        volume {
          name = "registration-dir"

          host_path {
            path = "/var/lib/kubelet/plugins_registry/"
            type = "Directory"
          }
        }

        volume {
          name = "efs-state-dir"

          host_path {
            path = "/var/run/efs"
            type = "DirectoryOrCreate"
          }
        }

        volume {
          name = "efs-utils-config"

          host_path {
            path = "/var/amazon/efs"
            type = "DirectoryOrCreate"
          }
        }

        volume {
          name = "efs-utils-config-legacy"

          host_path {
            path = "/etc/amazon/efs"
            type = "DirectoryOrCreate"
          }
        }

        container {
          name  = "efs-plugin"
          image = "amazon/aws-efs-csi-driver:${var.driver_release}"
          args = [
            "--endpoint=$(CSI_ENDPOINT)",
            "--logtostderr",
            "--v=${tostring(var.log_level)}",
            "--vol-metrics-opt-in=false",
            "--vol-metrics-refresh-period=240",
            "--vol-metrics-fs-rate-limit=5"
          ]

          port {
            name           = "healthz"
            container_port = 9809
            protocol       = "TCP"
          }

          env {
            name  = "CSI_ENDPOINT"
            value = "unix:/csi/csi.sock"
          }

          volume_mount {
            name              = "kubelet-dir"
            mount_path        = "/var/lib/kubelet"
            mount_propagation = "Bidirectional"
          }

          volume_mount {
            name       = "plugin-dir"
            mount_path = "/csi"
          }

          volume_mount {
            name       = "efs-state-dir"
            mount_path = "/var/run/efs"
          }

          volume_mount {
            name       = "efs-utils-config"
            mount_path = "/var/amazon/efs"
          }

          volume_mount {
            name       = "efs-utils-config-legacy"
            mount_path = "/etc/amazon/efs-legacy"
          }

          liveness_probe {
            http_get {
              path = "/healthz"
              port = "healthz"
            }

            initial_delay_seconds = 10
            timeout_seconds       = 3
            period_seconds        = 2
            failure_threshold     = 5
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            privileged = true
          }
        }

        container {
          name  = "csi-driver-registrar"
          image = "public.ecr.aws/eks-distro/kubernetes-csi/node-driver-registrar:v2.6.2-eks-1-25-latest"
          args = [
            "--csi-address=$(ADDRESS)",
            "--kubelet-registration-path=$(DRIVER_REG_SOCK_PATH)",
            "--v=${tostring(var.log_level)}",
          ]

          env {
            name  = "ADDRESS"
            value = "/csi/csi.sock"
          }

          env {
            name  = "DRIVER_REG_SOCK_PATH"
            value = "/var/lib/kubelet/plugins/efs.csi.aws.com/csi.sock"
          }

          env {
            name = "KUBE_NODE_NAME"

            value_from {
              field_ref {
                field_path = "spec.nodeName"
              }
            }
          }

          volume_mount {
            name       = "plugin-dir"
            mount_path = "/csi"
          }

          volume_mount {
            name       = "registration-dir"
            mount_path = "/registration"
          }

          image_pull_policy = "IfNotPresent"
        }

        container {
          name  = "liveness-probe"
          image = "public.ecr.aws/eks-distro/kubernetes-csi/livenessprobe:v2.8.0-eks-1-25-latest"
          args = [
            "--csi-address=/csi/csi.sock",
            "--health-port=9809",
            "--v=${tostring(var.log_level)}",
          ]

          volume_mount {
            name       = "plugin-dir"
            mount_path = "/csi"
          }

          image_pull_policy = "IfNotPresent"
        }

        dns_policy = "ClusterFirst"

        node_selector = {
          "kubernetes.io/os" = "linux"
        }

        service_account_name = local.node_name
        host_network         = true

        affinity {
          node_affinity {
            required_during_scheduling_ignored_during_execution {
              node_selector_term {
                match_expressions {
                  key      = "eks.amazonaws.com/compute-type"
                  operator = "NotIn"
                  values   = ["fargate"]
                }
              }
            }
          }
        }

        toleration {
          operator = "Exists"
        }

        priority_class_name = "system-node-critical"
      }
    }
  }
}
