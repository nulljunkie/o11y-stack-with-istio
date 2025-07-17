output "grafana_service_name" {
  description = "Name of the Grafana service"
  value       = "grafana"
}

output "grafana_nodeport" {
  description = "NodePort for Grafana access"
  value       = var.grafana_nodeport
}

output "grafana_admin_password" {
  description = "Grafana admin password"
  value       = var.grafana_admin_password
  sensitive   = true
}