
#Create Maria DB Server
resource "azurerm_mariadb_server" "MariaDB_Server" {
  name                = var.mariadb-srv
  location            = azurerm_resource_group.my-resource-group.location
  resource_group_name = azurerm_resource_group.my-resource-group.name

  sku_name = "GP_Gen5_2"

  storage_mb                   = 51200
  backup_retention_days        = 7
  geo_redundant_backup_enabled = false
  auto_grow_enabled                = true
  public_network_access_enabled    = true
  ssl_enforcement_enabled          = true
  ssl_minimal_tls_version_enforced = "TLS1_2"

  administrator_login          = var.mariadb-username
  administrator_login_password = var.mariadb-password
  version                      = "10.2"
#   depends_on = [
#     azurerm_virtual_network.my-vnet,
#     azurerm_subnet.MariaDB_Subnet
#   ]
}

resource "azurerm_mariadb_database" "Maria_DB" {
  name                = "mariadb_database"
  resource_group_name = azurerm_resource_group.my-resource-group.name
  server_name         = azurerm_mariadb_server.MariaDB_Server.name
  charset             = "utf8mb4"
  collation           = "utf8mb4_unicode_520_ci"
}

#Create Vnet Rule to allow access from "my-subent" subnet
resource "azurerm_mariadb_virtual_network_rule" "MariaDB_Rule01" {
  name                = "mariadb-vnet-rule01"
  resource_group_name = azurerm_resource_group.my-resource-group.name
  server_name         = azurerm_mariadb_server.MariaDB_Server.name
  subnet_id           = azurerm_subnet.my-subnet.id
  }