terraform {
  required_providers {
    kind = {
      source  = "tehcyx/kind"
      version = "0.4.0"
    }

    kubernetes = {
        source = "hashicorp/kubernetes"
        version = "2.22.0"
    }

    helm = {
        source = "hashicorp/helm"
        version = "2.10.1"
    }
  }

  required_version = ">=1.0.0"
}


