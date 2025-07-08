variable "namespace" {
  description = "Kubernetes namespace"
  type        = string
}

variable "client_image" {
  description = "Docker image for the client"
  type        = string
}

variable "server_service_name" {
  description = "Server service name"
  type        = string
}

variable "server_service_port" {
  description = "Server service port"
  type        = number
}