resource "azurerm_resource_group" "my-resource-group" {
  name     = var.resource_group_name
  location = var.location
}

# terraform {
#   backend "azurerm" {
#     # resource_group_name  = azurerm_resource_group.my-resource-group.name
#     # storage_account_name = azurerm_storage_account.Storage_Account.name
#     # container_name       = azurerm_storage_container.core-container.name
#     key                  = "terraform.tfstate"
#   }
# }

# Define App Service Plan
resource "azurerm_app_service_plan" "my-app-service-plan" {
  name                = var.app_service_plan_name
  location            = azurerm_resource_group.my-resource-group.location
  resource_group_name = azurerm_resource_group.my-resource-group.name
  kind                = var.app_service_Plan_Kind
  reserved            = true

  sku {
    tier = "Standard"
    size = "S1"
  }
    tags = {
          Environment: "${var.environment}-environment"
  }
}


#Define APP Service Frontend FE
resource "azurerm_app_service" "APP-service-FE" {
  name                = var.app_service_name_fe
  location            = azurerm_resource_group.my-resource-group.location
  resource_group_name = azurerm_resource_group.my-resource-group.name
  app_service_plan_id = azurerm_app_service_plan.my-app-service-plan.id

  site_config {
    dotnet_framework_version = "v4.0"
    scm_type                 = "LocalGit"
    always_on = true
  }

  #  connection_string {
  #   name  = "Database"
  #   type  = "SQLServer"
  #   value = "Server=mariadb-srv.mariadb.database.azure.com;Integrated Security=SSPI"
  # }

  identity {
    type = "SystemAssigned"
  }

  app_settings = {
    WEBSITE_VNET_ROUTE_ALL = "1"
  }
}


##Create Private endpoint for App service Frontend
resource "azurerm_private_endpoint" "private_endpoint_fe" {
  name                = "APP-service-FE-Private-Endpoint"
   location            = azurerm_resource_group.my-resource-group.location
  resource_group_name = azurerm_resource_group.my-resource-group.name
  subnet_id           = azurerm_subnet.subnet_endpoint.id

  private_service_connection {
    name                           = "APP-Service-fe-Service-Connection"
    private_connection_resource_id = azurerm_app_service.APP-service-FE.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "privatelink.azurewebsites.net"
    private_dns_zone_ids = [azurerm_private_dns_zone.private_zone.id]
  }
}

# Define App Service- Backend BE 01
resource "azurerm_app_service" "APP-service-be" {
  name                = var.app_service_name_be
  location            = azurerm_resource_group.my-resource-group.location
  resource_group_name = azurerm_resource_group.my-resource-group.name
  app_service_plan_id = azurerm_app_service_plan.my-app-service-plan.id

  site_config {
    dotnet_framework_version = "v4.0"
    scm_type                 = "LocalGit"
    always_on = true
  }

   connection_string {
    name  = "Database"
    type  = "SQLServer"
    value = "Server=mariadb-srv.mariadb.database.azure.com;Integrated Security=SSPI"
  }

  identity {
    type = "SystemAssigned"
  }

  app_settings = {
    WEBSITE_VNET_ROUTE_ALL = "1"
  }
}

##Create Private endpoint for App service BE 01
resource "azurerm_private_endpoint" "private_endpoint_be" {
  name                = "APP-Service-BE-Private-Endpoint"
   location            = azurerm_resource_group.my-resource-group.location
  resource_group_name = azurerm_resource_group.my-resource-group.name
  subnet_id           = azurerm_subnet.subnet_endpoint.id

  private_service_connection {
    name                           = "APP-Service-be-Service-Connection"
    private_connection_resource_id = azurerm_app_service.APP-service-be.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "privatelink.azurewebsites.net"
    private_dns_zone_ids = [azurerm_private_dns_zone.private_zone.id]
  }
}



# Define App Service- Backend BE 02
resource "azurerm_app_service" "APP-service-be02" {
  name                = var.app_service_name_be02
  location            = azurerm_resource_group.my-resource-group.location
  resource_group_name = azurerm_resource_group.my-resource-group.name
  app_service_plan_id = azurerm_app_service_plan.my-app-service-plan.id

  site_config {
    dotnet_framework_version = "v4.0"
    scm_type                 = "LocalGit"
    always_on = true
  }

   connection_string {
    name  = "Database"
    type  = "SQLServer"
    value = "Server=mariadb-srv.mariadb.database.azure.com;Integrated Security=SSPI"
  }

  identity {
    type = "SystemAssigned"
  }

  app_settings = {
    WEBSITE_VNET_ROUTE_ALL = "1"
  }
}

##Create Private endpoint for App service BE 02
resource "azurerm_private_endpoint" "private_endpoint_be02" {
  name                = "APP-Service-BE02-Private-Endpoint"
   location            = azurerm_resource_group.my-resource-group.location
  resource_group_name = azurerm_resource_group.my-resource-group.name
  subnet_id           = azurerm_subnet.subnet_endpoint.id

  private_service_connection {
    name                           = "APP-Service-be02-Service-Connection"
    private_connection_resource_id = azurerm_app_service.APP-service-be02.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "privatelink.azurewebsites.net"
    private_dns_zone_ids = [azurerm_private_dns_zone.private_zone.id]
  }
}

#Create Private endpoint for MariaDB Server
resource "azurerm_private_endpoint" "private_endpoint_Mariadb" {
  name                = "private_endpoint_Mariadb_Server"
   location            = azurerm_resource_group.my-resource-group.location
  resource_group_name = azurerm_resource_group.my-resource-group.name
  subnet_id           = azurerm_subnet.MariaDB_Subnet.id

  private_service_connection {
    name                           = "Mariadb-privateserviceconnection"
    private_connection_resource_id = azurerm_mariadb_server.MariaDB_Server.id
    subresource_names              = [ "mariadbServer" ]
    is_manual_connection           = false
  }
}

#create Vnet integration between App Service-Backend BE and MariaDB Subnet
resource "azurerm_app_service_virtual_network_swift_connection" "Vnet_integration_connection" {
  app_service_id = azurerm_app_service.APP-service-be.id
  subnet_id      = azurerm_subnet.my-subnet-StandAlone.id
}