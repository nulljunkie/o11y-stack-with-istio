variable "namespace" {
  description = "Kubernetes namespace for mesh resources"
  type        = string
}

variable "client_service_fqdn" {
  description = "FQDN of the client service"
  type        = string
}

variable "server_service_fqdn" {
  description = "FQDN of the server service"
  type        = string
}

variable "client_service_port" {
  description = "Port of the client service"
  type        = number
  default     = 80
}