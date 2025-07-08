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
