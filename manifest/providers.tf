terraform {
  required_providers {
    kind = {
      source  = "tehcyx/kind"
      version = "0.4.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.22.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "2.10.1"
    }
    local = {
      source = "hashicorp/local"
      version = "~> 2.5.3"
    }
    time = {
      source = "hashicorp/time"
      version = "~> 0.13.1"
    }
  }

  required_version = ">=1.0.0"
}


