variable "namespace" {
  description = "Namespace for EFS CSI driver resources"
  type        = string
  default     = "kube-system"
}

variable "log_level" {
  description = "The log level for the CSI Driver controller"
  default     = 2
  type        = number
}

variable "node_selector" {
  type        = map(string)
  default     = {}
  description = "NodeSelector map"
}

variable "driver_release" {
  type        = string
  default     = "v1.5.7"
  description = "The EFS CSI driver release version"
}

variable "csi_controller_replica_count" {
  description = "Number of EFS CSI driver controller pods"
  type        = number
  default     = 2
}

variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
  type        = map(string)
}

variable "delete_access_point_root_dir" {
  description = "Wheter to delete the access point root dir"
  type        = bool
  default     = false
}

variable "oidc_url" {
  description = "EKS OIDC provider URL, to allow pod to assume role using IRSA"
  type        = string
  default     = ""
}
