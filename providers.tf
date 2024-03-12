terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "= 2.12.1"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
    }
  }
}

provider "azurerm" {
  skip_provider_registration = true # This is only required when the User, Service Principal, or Identity running Terraform lacks the permissions to register Azure Resource Providers.
  features {}
}

data "azurerm_kubernetes_cluster" "credentials" {
  name                = azurerm_kubernetes_cluster.dl-dev.name
  resource_group_name = azurerm_resource_group.dl-dev.name
}

provider "kubectl" {
  host                   = azurerm_kubernetes_cluster.dl-dev.kube_config.0.host
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.dl-dev.kube_config.0.cluster_ca_certificate)
  load_config_file       = false
  token = yamldecode(azurerm_kubernetes_cluster.dl-dev.kube_config_raw).users[0].user.token
}
provider "helm" {
  kubernetes {
    host                   = data.azurerm_kubernetes_cluster.credentials.kube_config.0.host
    client_certificate     = base64decode(data.azurerm_kubernetes_cluster.credentials.kube_config.0.client_certificate)
    client_key             = base64decode(data.azurerm_kubernetes_cluster.credentials.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.credentials.kube_config.0.cluster_ca_certificate)

  }
}