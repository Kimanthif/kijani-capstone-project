resource "kubernetes_namespace" "staging" {
  metadata {
    name = "kijani-staging"
  }
}