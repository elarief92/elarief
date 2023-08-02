resource "azurerm_api_management_api" "composite-api" {
  name                = "composite-api"
  resource_group_name = azurerm_resource_group.my-resource-group.name
  api_management_name = azurerm_api_management.apim.name
  revision            = "1"
  display_name        = "Composite API"
  path                = "api"
  protocols           = ["https"]

/*
  import {
    content_format = "swagger-link-json"
    content_value  = "http://conferenceapi.azurewebsites.net/?format=json"
  }*/
}

resource "azurerm_api_management_api_operation" "operation1" {
  operation_id        = "user-get"
  api_name            = azurerm_api_management_api.composite-api.name
  api_management_name = azurerm_api_management.apim.name
  resource_group_name = azurerm_resource_group.my-resource-group.name
  display_name        = "Get User Operation"
  method              = "GET"
  url_template        = "/users/"
  description         = "This can only be done by the logged in user."

  response {
    status_code = 200
  }
}

/*
resource "azurerm_api_management_api_policy" "policy1" {
  api_name            = azurerm_api_management_api.composite-api.name
  api_management_name = azurerm_api_management.apim.name
  resource_group_name = azurerm_resource_group.rg.name
  operation_id = azurerm_api_management_api_operation.operation1.operation_id

  xml_content = <<XML
  <policies>
    <inbound>
      <set-backend-service id="apim-generated-policy" backend-id="first-serverles-function-app" />
    </inbound>
  </policies>
  XML
}*/