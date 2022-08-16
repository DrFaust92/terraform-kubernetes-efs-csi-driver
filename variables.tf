variable "namespace" {
  description = "Namespace for EFS CSI driver resources"
  type        = string
  default     = "kube-system"
}

variable "annotations" {
  description = "Optional annotations to add to EFS CSI driver resources"
  type        = map(string)
  default     = {}
}

variable "csi_controller_tolerations" {
  description = "CSI driver controller tolerations"
  type        = list(map(string))
  default     = []
}

variable "log_level" {
  description = "The log level for the CSI Driver controller"
  default     = 5
  type        = number
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

variable "node_extra_node_selectors" {
  description = "A map of extra node selectors for node pods"
  default     = {}
  type        = map(string)
}

variable "labels" {
  description = "A map of extra labels for all resources"
  default     = {}
  type        = map(string)
}

variable "host_aliases" {
  description = "A map of host aliases"
  default     = {}
  type        = map(any)
}

variable "create_controller" {
  description = "Whether to create a controller"
  type        = bool
  default     = false
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

variable "controller_annotations" {
  description = "A map of extra annotations for controller"
  default     = {}
  type        = map(string)
}

variable "oidc_url" {
  description = "EKS OIDC provider URL, to allow pod to assume role using IRSA"
  type        = string
  default     = ""
}

variable "efs_csi_controller_role_name" {
  description = "The name of the EFS CSI driver IAM role"
  default     = "efs-csi-driver-controller"
  type        = string
}

variable "efs_csi_controller_role_policy_name_prefix" {
  description = "The prefix of the EFS CSI driver IAM policy"
  default     = "efs-csi-driver-policy"
  type        = string
}
