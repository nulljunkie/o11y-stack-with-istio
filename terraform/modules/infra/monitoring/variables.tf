# Grafana configuration
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