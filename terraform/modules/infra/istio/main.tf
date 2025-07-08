module "base" {
  source = "./base"

  istio_version = var.istio_version
}

module "istiod" {
  source = "./istiod"

  istio_version   = var.istio_version
  istio_namespace = module.base.namespace

  depends_on = [module.base]
}

module "gateway" {
  source = "./gateway"

  istio_version   = var.istio_version
  http_nodeport   = var.gateway_http_nodeport
  https_nodeport  = var.gateway_https_nodeport

  depends_on = [module.istiod]
}

# Enable sidecar injection for the app namespace
resource "kubernetes_labels" "app_istio_injection" {
  api_version = "v1"
  kind        = "Namespace"
  
  metadata {
    name = var.app_namespace
  }
  
  labels = {
    "istio-injection" = "enabled"
  }

  depends_on = [module.istiod]
}
