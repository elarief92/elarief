
#Define Vnet
resource "azurerm_virtual_network" "my-vnet" {
  name                = var.vnet_name
  address_space       = var.vnet_Adress_Space
  location            = azurerm_resource_group.my-resource-group.location
  resource_group_name = azurerm_resource_group.my-resource-group.name
}

#Define Azure subnet
resource "azurerm_subnet" "my-subnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.my-resource-group.name
  virtual_network_name = azurerm_virtual_network.my-vnet.name
  address_prefixes     = var.subnet_service_Prefix
 enforce_private_link_service_network_policies = true
service_endpoints    = ["Microsoft.Sql"]

}

#Create subnet for maria DB Server 
resource "azurerm_subnet" "MariaDB_Subnet" {
  name                 = "Maria-DataBase-Subnet"
  resource_group_name  = azurerm_resource_group.my-resource-group.name
  virtual_network_name = azurerm_virtual_network.my-vnet.name
  address_prefixes     = var.subnet_mariaDB_Prefix
  
  service_endpoints    = ["Microsoft.Sql"]
  enforce_private_link_endpoint_network_policies = true 

  #Delegation for Vnet Integration
# delegation {
#     name = "delegation"

#     service_delegation {
#       name = "Microsoft.Web/serverFarms"
#     }
#   }
}


#Create Subnet for endpoints network
resource "azurerm_subnet" "subnet_endpoint" {
  name                 = "subnet_endpoint"
  resource_group_name  = azurerm_resource_group.my-resource-group.name
  virtual_network_name = azurerm_virtual_network.my-vnet.name
  address_prefixes     = var.subnet_endpoint_Prefix

  service_endpoints    = ["Microsoft.Sql"]
  enforce_private_link_endpoint_network_policies = true
}


#Define Network Security group
resource "azurerm_network_security_group" "NetworkNSG" {
  name                = "NSG-01"
  location            = azurerm_resource_group.my-resource-group.location
  resource_group_name = azurerm_resource_group.my-resource-group.name

  security_rule {
    name                       = "allow-rdp"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

#Define Subnet Association
resource "azurerm_subnet_network_security_group_association" "SubnetAssociation" {
  subnet_id                 = azurerm_subnet.my-subnet.id
  network_security_group_id = azurerm_network_security_group.NetworkNSG.id
}

#Define Virtual Machine Public IP
resource "azurerm_public_ip" "Virtual_Machine_PubIP" {
  name                = "Virtual_Machine_PublicIP"
  location            = azurerm_resource_group.my-resource-group.location
  resource_group_name = azurerm_resource_group.my-resource-group.name
  allocation_method   = "Dynamic"
}

#Define Virtual network interface card for the machine
resource "azurerm_network_interface" "Virtual_Machine_Vnic" {
  name                = "NIC-01"
  location            = azurerm_resource_group.my-resource-group.location
  resource_group_name = azurerm_resource_group.my-resource-group.name

  ip_configuration {
    name                          = "Vnic-ipconfig"
    subnet_id                     = azurerm_subnet.my-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.Virtual_Machine_PubIP.id
  }
}

#
resource "azurerm_private_dns_zone" "private_zone" {
  name                = "privatelink.azurewebsites.net"
  resource_group_name = azurerm_resource_group.my-resource-group.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "private_zone_links" {
  name                  = "link-to-myVnet"
  resource_group_name   = azurerm_resource_group.my-resource-group.name
  private_dns_zone_name = azurerm_private_dns_zone.private_zone.name
  virtual_network_id    = azurerm_virtual_network.my-vnet.id
}

###############################################################
###############################################################
#Define StandAlone Azure subnet
resource "azurerm_subnet" "my-subnet-StandAlone" {
  name                 = "StandAlone_Subnet"
  resource_group_name  = azurerm_resource_group.my-resource-group.name
  virtual_network_name = azurerm_virtual_network.my-vnet.name
  address_prefixes     = ["10.0.10.0/24"]
 enforce_private_link_service_network_policies = true
service_endpoints    = ["Microsoft.Sql"]
delegation {
    name = "example-delegation"

    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}