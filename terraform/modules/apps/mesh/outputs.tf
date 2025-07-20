output "gateway_name" {
  description = "Name of the Istio Gateway"
  value       = kubernetes_manifest.client_gateway.manifest.metadata.name
}

output "virtualservice_name" {
  description = "Name of the Istio VirtualService"
  value       = kubernetes_manifest.client_virtual_service.manifest.metadata.name
}