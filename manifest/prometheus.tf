resource "helm_release" "prometheus" {
  depends_on       = [kind_cluster.default, time_sleep.wait_for_cluster]
  name             = var.prometheus_name
  repository       = var.prometheus_repo
  chart            = var.prometheus_name
  version          = var.prometheus_version
  namespace        = "monitoring"
  create_namespace = "true"
  timeout          = 600

  values = [
    <<EOF
        defaultRules:
          create: true
        prometheus:
          enabled: true
        alertmanager:
          enabled: true
        grafana:
          enabled: false
        kubeStateMetrics:
          enabled: true
        nodeExporter:
          enabled: true
        EOF
  ]
}
