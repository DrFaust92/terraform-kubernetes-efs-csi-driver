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