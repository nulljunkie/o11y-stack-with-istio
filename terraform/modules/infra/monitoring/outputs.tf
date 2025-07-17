output "grafana_nodeport" {
  description = "Grafana NodePort for external access"
  value       = module.grafana.grafana_nodeport
}

output "grafana_admin_password" {
  description = "Grafana admin password"
  value       = module.grafana.grafana_admin_password
  sensitive   = true
}