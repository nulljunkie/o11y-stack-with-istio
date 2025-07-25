variable "namespace" {
  description = "Kubernetes namespace for the application"
  type        = string
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

variable "server_port" {
  description = "Port for the quote server application"
  type        = number
}

variable "postgres_init_sql_file" {
  description = "Path to PostgreSQL initialization SQL file"
  type        = string
}

variable "server_image" {
  description = "Container image for the quote server application"
  type        = string
}

variable "client_v1_image" {
  description = "Container image for the quote client application"
  type        = string
}

variable "client_v2_image" {
  description = "Container image for the quote client v2 application"
  type        = string
}

variable "grafana_admin_password" {
  description = "Admin password for Grafana"
  type        = string
  sensitive   = true
}

variable "grafana_nodeport" {
  description = "NodePort for Grafana service"
  type        = number
  default     = 30300
}
