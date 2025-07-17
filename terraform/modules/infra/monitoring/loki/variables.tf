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