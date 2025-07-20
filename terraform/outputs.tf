output "postgres_service_name" {
  description = "PostgreSQL service name"
  value       = module.infra.postgres_service_name
}

output "postgres_service_port" {
  description = "PostgreSQL service port"
  value       = module.infra.postgres_service_port
}

output "server_service_name" {
  description = "Server service name"
  value       = module.apps.server_service_name
}

output "server_service_port" {
  description = "Server service port"
  value       = module.apps.server_service_port
}

output "client_service_name" {
  description = "Client service name"
  value       = module.apps.client_service_name
}

output "client_node_port" {
  description = "Client NodePort for external access"
  value       = module.apps.client_node_port
}

output "istio_gateway_http_port" {
  description = "Istio Gateway HTTP NodePort"
  value       = module.infra.istio_gateway_nodeport_http
}

output "istio_gateway_https_port" {
  description = "Istio Gateway HTTPS NodePort"
  value       = module.infra.istio_gateway_nodeport_https
}

# output "grafana_nodeport" {
#   description = "Grafana NodePort for external access"
#   value       = module.infra.grafana_nodeport
# }

# output "grafana_admin_password" {
#   description = "Grafana admin password"
#   value       = module.infra.grafana_admin_password
#   sensitive   = true
# }
