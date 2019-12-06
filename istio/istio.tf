data "helm_repository" "istio" {
  name = lookup(var.istio, "repo_name")
  url  = lookup(var.istio, "repo_url")
}

resource "helm_release" "istio-init" {
  name       = "istio-init"
  repository = data.helm_repository.istio.metadata[0].name
  chart      = "istio-init"
  version    = lookup(var.istio, "version")
  namespace  = lookup(var.istio, "namespace")
}

resource "null_resource" "istio-wait" {
  depends_on       = [helm_release.istio-init]
  provisioner "local-exec" {
    command = "kubectl -n istio-system wait --for=condition=complete job --all"    
  }
}

resource "helm_release" "istio" {
  depends_on        = [null_resource.istio-wait]
  name              = "istio"
  repository        = data.helm_repository.istio.metadata[0].name
  chart             = "istio"
  version           = lookup(var.istio, "version")
  namespace         = lookup(var.istio, "namespace")
}
