resource "helm_release" "kyverno" {
  name             = "kyverno"
  chart            = "kyverno"
  repository       = "https://kyverno.github.io/kyverno/"
  version          = "2.5.4"
  namespace        = "kyverno"
  create_namespace = true
  depends_on = [helm_release.ingress_nginx]   

  set {
    name  = "admissionController.replicas"
    value = 3
  }
  set {
    name  = "backgroundController.replicas"
    value = 2
  }

  set {
    name  = "cleanupController.replicas"
    value = 2
  }
  set {
    name  = "reportsController.replicas"
    value = 2
  }

  set {
    name  = "namespace"
    value = "kyverno"
  }
}

resource "null_resource" "wait_for_kyverno" {
  triggers = {
    key = uuid()
  }

  provisioner "local-exec" {

    command = <<EOF
      printf "\nWaiting for the kyverno pods to start...\n"
      sleep 5
      until kubectl wait -n ${helm_release.kyverno.namespace} --for=condition=Ready pods --all; do
        sleep 2
      done  2>/dev/null
    EOF
  }

  depends_on = [helm_release.kyverno]
}
