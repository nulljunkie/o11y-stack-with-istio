output "istio_namespace" {
  description = "Istio system namespace"
  value       = module.base.namespace
}

output "gateway_http_nodeport" {
  description = "Gateway HTTP NodePort"
  value       = module.gateway.http_nodeport
}

output "gateway_https_nodeport" {
  description = "Gateway HTTPS NodePort"
  value       = module.gateway.https_nodeport
}

output "gateway_service_name" {
  description = "Gateway service name"
  value       = module.gateway.gateway_service_name
}

output "gateway_namespace" {
  description = "Gateway namespace"
  value       = module.gateway.gateway_namespace
}