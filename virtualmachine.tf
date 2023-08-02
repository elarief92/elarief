resource "azurerm_windows_virtual_machine" "VirtualMachine-01" {
  name                = "Machine01"
  location            = azurerm_resource_group.my-resource-group.location
  resource_group_name = azurerm_resource_group.my-resource-group.name
  size                = "Standard_F2"
  admin_username      = var.VM-Username
  admin_password      = var.VM-Password
  network_interface_ids = [
    azurerm_network_interface.Virtual_Machine_Vnic.id
  ]
  tags = {
          Environment: "${var.environment}-environment"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}

#Create Storage account
# resource "azurerm_storage_account" "Storage_Account" {
#   depends_on = [azurerm_resource_group.my-resource-group]
#   name                     = var.Storage-Account
#   resource_group_name      = azurerm_resource_group.my-resource-group.name
#   location                 = azurerm_resource_group.my-resource-group.location
#   account_tier             = var.Storage-Account-tier
#   account_replication_type = var.Storage-Account-Type

#     tags = {
#           Environment: "${var.environment}-environment"
#   }
# }
# # Create a Storage Container for the Core State File
# resource "azurerm_storage_container" "core-container" {
#   depends_on = [azurerm_storage_account.Storage_Account]
  
#   name                 = "${var.cont-name}-Container"
#   storage_account_name = azurerm_storage_account.Storage_Account.name
# }