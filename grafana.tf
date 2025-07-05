resource "helm_release" "grafana" {
  name             = "grafana"
  chart            = "grafana"
  repository       = "https://grafana.github.io/helm-charts"
  namespace        = "monitoring"
  create_namespace = "true"
  version          = "6.53.0"
  depends_on       = [helm_release.prometheus, time_sleep.wait_for_cluster]


  values = [
    <<EOF
      service:
        type: ClusterIP
        port: 80
      ingress:
        enabled: false
      adminUser: admin
      adminPassword: admin1234567890
      datasources:
        datasource.yaml:
          apiVersion: 1
          datasources:
            - name: Prometheus
              type: prometheus
              orgId: 1
              url: http://prometheus-kube-prometheus-prometheus.monitoring.svc.cluster.local:9090
              access: proxy
              basicAuth: false
    EOF
  ]
}
