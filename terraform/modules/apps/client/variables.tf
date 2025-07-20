variable "namespace" {
  description = "Kubernetes namespace"
  type        = string
}

variable "client_v1_image" {
  description = "Docker image for the client v1"
  type        = string
}

variable "client_v2_image" {
  description = "Docker image for the client v2"
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
