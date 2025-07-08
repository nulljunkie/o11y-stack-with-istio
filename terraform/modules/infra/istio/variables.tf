variable "istio_version" {
  description = "Istio version to install"
  type        = string
  default     = "1.26.2"
}

variable "app_namespace" {
  description = "Application namespace to enable Istio injection"
  type        = string
}

variable "gateway_http_nodeport" {
  description = "NodePort for HTTP traffic"
  type        = number
  default     = 30080
}

variable "gateway_https_nodeport" {
  description = "NodePort for HTTPS traffic"
  type        = number
  default     = 30443
}
