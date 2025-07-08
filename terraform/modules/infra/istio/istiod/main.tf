resource "helm_release" "istiod" {
  name       = "istiod"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "istiod"
  namespace  = var.istio_namespace
  version    = var.istio_version

  wait    = true
  timeout = 300

  values = [
    yamlencode({
      telemetry = {
        v2 = {
          enabled = true
        }
      }
      global = {
        meshID                      = "mesh1"
        multiCluster = {
          clusterName = "cluster1"
        }
        network = "network1"
      }
    })
  ]
}
