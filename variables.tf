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