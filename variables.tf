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