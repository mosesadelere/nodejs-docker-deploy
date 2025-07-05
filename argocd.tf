resource "helm_release" "argocd" {
  depends_on       = [kind_cluster.default, time_sleep.wait_for_cluster]
  name             = "argocd"
  namespace        = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  create_namespace = "true"

  values = [
    <<EOF
    server:
      services:
        type: ClusterIP
    EOF
  ]
}