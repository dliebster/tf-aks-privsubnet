# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

output "id" {
  value = azurerm_kubernetes_cluster.dl-dev.id
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.dl-dev.kube_config_raw
  sensitive = true
}
resource "local_file" "kubeconfig" {
  depends_on   = [azurerm_kubernetes_cluster.dl-dev]
  filename     = "./kube_config"
  content      = azurerm_kubernetes_cluster.dl-dev.kube_config_raw
}
output "client_key" {
  value = azurerm_kubernetes_cluster.dl-dev.kube_config.0.client_key
  sensitive = true
}

output "client_certificate" {
  value = azurerm_kubernetes_cluster.dl-dev.kube_config.0.client_certificate
  sensitive = true
}

output "cluster_ca_certificate" {
  value = azurerm_kubernetes_cluster.dl-dev.kube_config.0.cluster_ca_certificate
  sensitive = true
}

output "host" {
  value = azurerm_kubernetes_cluster.dl-dev.kube_config.0.host
  sensitive = true
}
