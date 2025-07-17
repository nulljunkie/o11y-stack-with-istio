resource "kubernetes_config_map" "postgres_init" {
  metadata {
    name      = "postgres-init-scripts"
    namespace = var.namespace
  }

  data = {
    "init.sql" = file(var.init_sql_file)
  }
}

resource "helm_release" "postgresql" {
  name       = "postgresql"
  repository = "oci://registry-1.docker.io/bitnamicharts"
  chart      = "postgresql"
  version    = "16.6.3"
  namespace  = var.namespace

  values = [
    yamlencode({
      fullnameOverride = "postgres"
      auth = {
        postgresPassword = var.password
        username         = var.username
        password         = var.password
        database         = var.database
      }
      primary = {
        persistence = {
          enabled = true
          size    = "2Gi"
        }
        initdb = {
          scriptsConfigMap = "postgres-init-scripts"
        }
      }
    })
  ]

  depends_on = [kubernetes_config_map.postgres_init]
}
