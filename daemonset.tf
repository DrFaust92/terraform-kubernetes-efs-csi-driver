resource "kubernetes_daemonset" "efs" {
  metadata {
    name      = local.name
    namespace = var.namespace
  }

  spec {
    selector {
      match_labels = local.labels
    }

    template {
      metadata {
        labels      = merge(local.labels, var.labels)
        annotations = var.annotations
      }

      spec {
        node_selector = merge({
          "beta.kubernetes.io/os" : "linux",
        }, var.extra_node_selectors, var.node_extra_node_selectors)

        dynamic "host_aliases" {
          for_each = var.host_aliases
          content {
            ip        = lookup(toleration.value, "ip", null)
            hostnames = lookup(toleration.value, "hostnames", null)
          }
        }

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
          name              = "efs-plugin"
          image             = "amazon/aws-efs-csi-driver:v2.0.9"
          image_pull_policy = "IfNotPresent"

          args = ["--endpoint=$(CSI_ENDPOINT)", "--logtostderr", "--v=${tostring(var.log_level)}"]

          env {
            name  = "CSI_ENDPOINT"
            value = "unix:/csi/csi.sock"
          }

          volume_mount {
            mount_path        = "/var/lib/kubelet"
            name              = "kubelet-dir"
            mount_propagation = "Bidirectional"
          }

          volume_mount {
            mount_path = "/csi"
            name       = "plugin-dir"
          }

          volume_mount {
            mount_path = "/var/run/efs"
            name       = "efs-state-dir"
          }

          volume_mount {
            mount_path = "/etc/amazon/efs"
            name       = "efs-utils-config"
          }

          port {
            name           = "healthz"
            container_port = 9809
            protocol       = "TCP"
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

          readiness_probe {
            http_get {
              path = "/healthz"
              port = "healthz"
            }

            initial_delay_seconds = 10
            timeout_seconds       = 3
            period_seconds        = 2
            failure_threshold     = 5
          }

          security_context {
            privileged = true
          }
        }

        container {
          name  = "csi-driver-registrar"
          image = "public.ecr.aws/eks-distro/kubernetes-csi/node-driver-registrar:v2.1.0-eks-1-18-13"
          args  = ["--csi-address=$(ADDRESS)", "--kubelet-registration-path=$(DRIVER_REG_SOCK_PATH)", "--v=5"]

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
            mount_path = "/csi"
            name       = "plugin-dir"
          }

          volume_mount {
            mount_path = "/registration"
            name       = "registration-dir"
          }
        }

        container {
          name  = "liveness-probe"
          image = "public.ecr.aws/eks-distro/kubernetes-csi/livenessprobe:v2.2.0-eks-1-18-13"
          args  = ["--csi-address=/csi/csi.sock", "--health-port=9809"]

          volume_mount {
            mount_path = "/csi"
            name       = "plugin-dir"
          }
        }

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
            path = "/etc/amazon/efs"
            type = "DirectoryOrCreate"
          }
        }

        host_network        = true
        priority_class_name = "system-node-critical"
      }
    }
  }
}