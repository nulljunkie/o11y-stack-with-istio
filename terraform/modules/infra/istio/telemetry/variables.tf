variable "istio_namespace" {
  description = "Namespace where Istio is installed"
  type        = string
  default     = "istio-system"
}