variable "kind_cluster_name" {
  type        = string
  description = "Name of the cluster."
  default     = "demo-git-action"
}

variable "kind_cluster_config_path" {
  type        = string
  description = "Location where cluster's kubeconfig resides."
  default     = "~/.kube/config"
}

variable "ingress_nginx_namespace" {
  type        = string
  description = "Nginx ingress namespace, provided it is created"
  default     = "ingress-nginx"
}

variable "ingress_nginx_helm_version" {
  type        = string
  description = "Helm version for the nginx ingress controller."
  default     = "4.7.1"
}

variable "prometheus_name" {
  type        = string
  description = "Prometheus name"
  default     = "prometheus"
}

variable "prometheus_version" {
  type        = string
  description = "Version number for prometheus"
  default     = "15.0.0"
}

variable "prometheus_repo" {
  type    = string
  default = "https://prometheus-community.github.io/helm-charts"
}



