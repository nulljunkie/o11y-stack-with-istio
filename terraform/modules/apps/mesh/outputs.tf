output "gateway_name" {
  description = "Name of the Istio Gateway"
  value       = kubernetes_manifest.quote_gateway.manifest.metadata.name
}

output "virtualservice_name" {
  description = "Name of the Istio VirtualService"
  value       = kubernetes_manifest.quote_client_vs.manifest.metadata.name
}
