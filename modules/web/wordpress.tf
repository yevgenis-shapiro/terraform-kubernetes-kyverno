provider "kubernetes" {
    config_path="~/.kube/config"
}

###-deployment
resource "kubernetes_deployment" "wp-dep" {
  metadata {
    name = "wp-dep"
    labels = {
      app = "wordpress"

    }
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "wordpress"
      }
    }

    template {
      metadata {
        labels = {
          app = "wordpress"
        }
      }
      spec {
        container {
          image = "wordpress"
          name  = "wordpress-pod"

          port {
            container_port = 80
          }
        }
      }
    }
  }
  #depends_on = [helm_release.argocd]
}

###-service
resource "kubernetes_service" "wp_svc" {
  metadata {
    name = "wp-service"
    labels = {
      app = "wordpress"
    }
  }
  spec {
    selector = {
      app = "wordpress"

    }
    port {
      port        = 80
      target_port = 8080
    }
    type = "ClusterIP"
  }
  #depends_on = [helm_release.argocd]
}
