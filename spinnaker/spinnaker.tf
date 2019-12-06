data "helm_repository" "stable" {
  name = "stable"
  url  = "https://kubernetes-charts.storage.googleapis.com"
}

resource "helm_release" "spinnaker" {
  name       = "spinnaker"
  repository = data.helm_repository.stable.metadata[0].name
  chart      = "spinnaker"

  values = [
    file("values.yaml")
  ]
}
