output "kubeconfig" {
  value = kind_cluster.default.kubeconfig
}

output "endpoint" {
  value = kind_cluster.default.endpoint
}

output "client_certificate" {
  value = kind_cluster.default.client_certificate
}

output "client_key" {
  value = kind_cluster.default.client_key
}

output "cluster_ca_certificate" {
  value = kind_cluster.default.cluster_ca_certificate
}

output "grafana_url" {
  description = "URL to access Grafana dashboard"
  value       = "http://grafana.monitoring.svc.cluster.local:80"
}

output "prometheus_url" {
  description = "URL to access Prometheus dashboard"
  value       = "http://prometheus-kube-prometheus-prometheus.monitoring.svc.cluster.local:9090"
}
