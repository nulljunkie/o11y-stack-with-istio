resource "kubernetes_deployment" "client_v1" {
  metadata {
    name      = "client-v1"
    namespace = var.namespace
    labels = {
      app = "client"
      version = "v1"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "client"
        version = "v1"
      }
    }

    template {
      metadata {
        labels = {
          app = "client"
          version = "v1"
        }
      }

      spec {
        container {
          image             = var.client_v1_image
          image_pull_policy = "IfNotPresent"
          name              = "client"

          port {
            container_port = 8080
          }

          env {
            name  = "SERVER_HOST"
            value = var.server_service_name
          }

          env {
            name  = "SERVER_PORT"
            value = tostring(var.server_service_port)
          }

          env {
            name  = "VERSION"
            value = "v1"
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment" "client_v2" {
  metadata {
    name      = "client-v2"
    namespace = var.namespace
    labels = {
      app = "client"
      version = "v2"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "client"
        version = "v2"
      }
    }

    template {
      metadata {
        labels = {
          app = "client"
          version = "v2"
        }
      }

      spec {
        container {
          image             = var.client_v2_image
          image_pull_policy = "IfNotPresent"
          name              = "client"

          port {
            container_port = 8080
          }

          env {
            name  = "SERVER_HOST"
            value = var.server_service_name
          }

          env {
            name  = "SERVER_PORT"
            value = tostring(var.server_service_port)
          }

          env {
            name  = "VERSION"
            value = "v2"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "client" {
  metadata {
    name      = "client-service"
    namespace = var.namespace
  }

  spec {
    selector = {
      app = "client"
    }

    port {
      port        = 80
      target_port = 8080
    }

    type = "NodePort"
  }
}
