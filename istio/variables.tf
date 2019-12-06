variable "istio" {
  type = map(string)
  default = {
    "namespace" = "istio-system"
    "version"   = "1.4.0"
    "repo_name" = "istio.io"
    "repo_url"  = "https://storage.googleapis.com/istio-release/releases/1.4.0/charts/"
  }
}
