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

variable "annotations" {
  description = "Optional annotations to add to EFS CSI driver resources"
  type        = map(string)
  default     = {}
}

variable "controller_annotations" {
  description = "A map of extra annotations for controller"
  default     = {}
  type        = map(string)
}

variable "labels" {
  description = "A map of extra labels for all resources"
  default     = {}
  type        = map(string)
}

variable "extra_node_selectors" {
  description = "A map of extra node selectors for all components"
  default     = {}
  type        = map(string)
}

variable "controller_extra_node_selectors" {
  description = "A map of extra node selectors for controller pods"
  default     = {}
  type        = map(string)
}

variable "csi_controller_tolerations" {
  description = "CSI driver controller tolerations"
  type        = list(map(string))
  default     = []
}

variable "efs_csi_controller_role_name" {
  description = "The name of the EFS CSI driver IAM role"
  default     = ""
  type        = string
}

variable "efs_csi_controller_role_policy_name_prefix" {
  description = "The prefix of the EFS CSI driver IAM policy"
  default     = ""
  type        = string
}
