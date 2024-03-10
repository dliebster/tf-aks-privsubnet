terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  skip_provider_registration = true # This is only required when the User, Service Principal, or Identity running Terraform lacks the permissions to register Azure Resource Providers.
  features {}
}

resource "azurerm_resource_group" "dl-dev" {
  name     = "${var.prefix}-k8s-resources"
  location = var.location
}

resource "azurerm_virtual_network" "dl-dev" {
  name                = "${var.prefix}-network"
  location            = azurerm_resource_group.dl-dev.location
  resource_group_name = azurerm_resource_group.dl-dev.name
  address_space       = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  virtual_network_name = azurerm_virtual_network.dl-dev.name
  resource_group_name  = azurerm_resource_group.dl-dev.name
  address_prefixes     = ["10.1.0.0/22"]
}

resource "azurerm_kubernetes_cluster" "dl-dev" {
  name                = "${var.prefix}-k8s"
  location            = azurerm_resource_group.dl-dev.location
  resource_group_name = azurerm_resource_group.dl-dev.name
  dns_prefix          = "${var.prefix}-k8s"

  default_node_pool {
    name           = "system"
    node_count     = 1
    vm_size        = "Standard_DS2_v2"
    vnet_subnet_id = azurerm_subnet.internal.id
  }

  identity {
    type = "SystemAssigned"
  }

  private_cluster_enabled = true
}

resource "azurerm_kubernetes_cluster_node_pool" "user" {
  name                  = "dlnodes01"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.dl-dev.id
  vm_size               = "Standard_DS2_v2"
  node_count            = 1
  vnet_subnet_id        = azurerm_subnet.internal.id
}
