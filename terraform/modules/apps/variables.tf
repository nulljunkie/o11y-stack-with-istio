variable "namespace" {
  description = "Kubernetes namespace"
  type        = string
}

variable "server_image" {
  description = "Docker image for the server"
  type        = string
}

variable "server_port" {
  description = "Port for the server application"
  type        = number
}

variable "client_v1_image" {
  description = "Docker image for the client"
  type        = string
}

variable "client_v2_image" {
  description = "Docker image for the client v2"
  type        = string
}

variable "postgres_host" {
  description = "PostgreSQL host"
  type        = string
}

variable "postgres_port" {
  description = "PostgreSQL port"
  type        = number
}

variable "postgres_database" {
  description = "PostgreSQL database name"
  type        = string
}

variable "postgres_username" {
  description = "PostgreSQL username"
  type        = string
}

variable "postgres_password" {
  description = "PostgreSQL password"
  type        = string
  sensitive   = true
}
