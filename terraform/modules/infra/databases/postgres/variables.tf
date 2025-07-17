variable "namespace" {
  description = "Kubernetes namespace"
  type        = string
}

variable "database" {
  description = "PostgreSQL database name"
  type        = string
}

variable "username" {
  description = "PostgreSQL username"
  type        = string
}

variable "password" {
  description = "PostgreSQL password"
  type        = string
  sensitive   = true
}

variable "init_sql_file" {
  description = "Path to SQL initialization file"
  type        = string
}