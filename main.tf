provider "kind" {}

provider "kubernetes" {
  config_paths = pathexpand(var.kind_cluster_config_path)
}

provider "helm" {
  kubernetes {
    config_path = pathexpand(var.kind_cluster_config_path)
  }
}

resource "kind_cluster" "default" {
  name            = var.kind_cluster_name
  node_image      = "kindest/node:v1.27.1"
  kubeconfig_path = pathexpand(var.kind_cluster_config_path)
  wait_for_ready  = true

  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"
    node {
      role = "control-plane"
      extra_port_mappings {
        container_port = 80
        host_port      = 80
      }
      extra_port_mappings {
        container_port = 443
        host_port      = 443
      }
      kubeadm_config_patches = [
        <<EOF
          kind: InitConfiguration
          nodeRegistration:
            kubeletExtraArgs:
              node-labels:  "ingress-ready=true"
        EOF
      ]
    }
    node {
      role = "worker"
    }
  }
}

resource "time_sleep" "wait_for_cluster" {
  depends_on      = [kind_cluster.default]
  create_duration = "60s"
}

resource "helm_release" "ingress_nginx" {
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = var.ingress_nginx_helm_version
  timeout    = 600

  namespace        = var.ingress_nginx_namespace
  create_namespace = true

  values = [
    <<EOF
      controller:
        hostPort:
          enabled: true
        terminationGracePeriodSeconds: 0
        service:
          type: NodePort
        watchIngressWithoutClass: true
        nodeSelector:
          ingress-ready: "true"
        tolerations:
        -
          effect: "NoSchedule"
          key: "node-role.kubernetes.io/master"
          operator: "Equal"
        -
          effect: "NoSchedule"
          key: "node-role.kubernetes.io/control-plane"
          operator: "Equal"
        publishService:
          enabled: false
        extraArgs:
          publish-status-address: "localhost"
    EOF
  ]

  depends_on = [time_sleep.wait_for_cluster]
}
