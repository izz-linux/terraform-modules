resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location

  tags = var.tags
}

module "aks" {
  source = "../"

  cluster_name        = var.cluster_name
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  kubernetes_version  = var.kubernetes_version

  default_node_pool = {
    name       = "default"
    vm_size    = "Standard_D2S_v3"
    node_count = 2
  }

  network_profile = {
    network_plugin = "azure"
  }

  tags = var.tags
}
