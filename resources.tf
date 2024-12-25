

###-kong
resource "helm_release" "kong" {
  name       = "kong"

  repository = "https://charts.konghq.com"
  chart      = "kong"
  create_namespace = true
  wait             = true
  set {
    name  = "ingressController.enabled"
    value = "true"
  }

  set {
    name  = "admin.enabled"
    value = "true"
  }

  set {
    name  = "admin.http.enabled"
    value = "true"
  }
  
  set {
    name  = "proxy.enabled"
    value = "true"
  }
  
  set {
    name  = "proxy.type"
    value = "ClusterIP"
  }

  set {
    name  = "ingressController.installCRDs"
    value = "false"
  }
  depends_on = [helm_release.argocd]
}




