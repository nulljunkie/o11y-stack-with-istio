variable "chart_repository" {
  description = "Helm repository for the chart"
  type        = string
}

variable "chart_name" {
  description = "Helm chart name"
  type        = string
}

variable "chart_version" {
  description = "Helm chart version"
  type        = string
}

variable "monitoring_namespace" {
  description = "Kubernetes namespace for monitoring stack"
  type        = string
  default     = "monitoring"
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