output "postgres_service_name" {
  description = "PostgreSQL service name"
  value       = module.postgres.service_name
}

output "postgres_service_port" {
  description = "PostgreSQL service port"
  value       = module.postgres.service_port
}

output "istio_gateway_nodeport_http" {
  description = "Istio Gateway NodePort for HTTP"
  value       = module.istio.gateway_http_nodeport
}

output "istio_gateway_nodeport_https" {
  description = "Istio Gateway NodePort for HTTPS"
  value       = module.istio.gateway_https_nodeport
}