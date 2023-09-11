terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.14.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "engenhos" {
  name     = "engenhos"
  location = "West Europe"
}

resource "azurerm_kubernetes_cluster" "engenhos" {
  name                = "engenhos-aks"
  location            = azurerm_resource_group.engenhos.location
  resource_group_name = azurerm_resource_group.engenhos.name
  dns_prefix          = "engenhosaks"

  default_node_pool {
    name       = "default"
    node_count = 2
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

}

resource "azurerm_redis_cache" "engenhos" {
  name                = "engenhos-redis"
  location            = azurerm_resource_group.engenhos.location
  resource_group_name = azurerm_resource_group.engenhos.name
  capacity            = 2
  family              = "C"
  sku_name            = "Standard"
  enable_non_ssl_port = false
  minimum_tls_version = "1.2"

  redis_configuration {
  }
}

resource "azurerm_resource_group" "example" {
  name     = "database-rg"
  location = "West Europe"
}

resource "azurerm_mssql_server" "engenhos-sql-server" {
  name                         = "engenhos-sql-server"
  resource_group_name          = azurerm_resource_group.engenhos.name
  location                     = azurerm_resource_group.engenhos.location
  version                      = "12.0"
  administrator_login          = "paula"
  administrator_login_password = "#tra%3498"
  minimum_tls_version          = "1.2"
  public_network_access_enabled = false
}

resource "azurerm_mssql_database" "dbfenix" {
  name    = "dbfenix"
  server_id = azurerm_mssql_server.engenhos-sql-server.id
  
}