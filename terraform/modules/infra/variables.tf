variable "namespace" {
  description = "Kubernetes namespace"
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

variable "postgres_init_sql_file" {
  description = "Path to PostgreSQL initialization SQL file"
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
