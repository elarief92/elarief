resource "azurerm_api_management_backend" "backend01" {
  name                = "backend01"
  resource_group_name = azurerm_resource_group.my-resource-group.name
  api_management_name = azurerm_api_management.apim.name
  protocol            = "http"
  url                 = "https://my-app-service-be.azurewebsites.net/"
}

resource "azurerm_api_management_backend" "backend02" {
  name                = "backend02"
  resource_group_name = azurerm_resource_group.my-resource-group.name
  api_management_name = azurerm_api_management.apim.name
  protocol            = "http"
  url                 = "https://my-app-service-be02.azurewebsites.net/"
}