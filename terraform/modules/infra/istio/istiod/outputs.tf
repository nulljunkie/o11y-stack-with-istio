output "istiod_release_name" {
  description = "Istiod release name"
  value       = helm_release.istiod.name
}

output "istiod_namespace" {
  description = "Istiod namespace"
  value       = helm_release.istiod.namespace
}