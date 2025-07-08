variable "istio_version" {
  description = "Istio version to install"
  type        = string
  default     = "1.22.0"
}

variable "http_nodeport" {
  description = "NodePort for HTTP traffic"
  type        = number
  default     = 30080
}

variable "https_nodeport" {
  description = "NodePort for HTTPS traffic"
  type        = number
  default     = 30443
}