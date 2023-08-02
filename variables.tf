variable "subscription_id" {
  type    = string
}

variable "client_id" {
  type    = string
}

variable "client_secret" {
  type    = string
}

variable "tenant_id" {
  type    = string
}
variable "environment" {
  type    = string
}

variable "resource_group_name" {
  type    = string
}

variable "location" {
  type    = string
}

variable "app_service_plan_name" {
  type    = string
}

variable "app_service_Plan_Kind" {
  type    = string
}

variable "app_service_name_be" {
  type    = string
}

variable "app_service_name_be02" {
  type    = string
}

variable "app_service_name_fe" {
  type    = string
}

variable "API_management_name" {
  type    = string

}

variable "vnet_name" {
  type    = string
}

variable "vnet_Adress_Space" {
  type    = list
}

variable "subnet_name" {
  type    = string
}

variable "subnet_service_Prefix" {
  type    = list
}

variable "subnet_endpoint_Prefix" {
  type    = list
}

variable "subnet_mariaDB_Prefix" {
  type    = list
}

variable "private_endpoint_name" {
  type    = string
}

variable "Private_Service_Connection_Name" {
  type    = string
}

variable "mariadb-srv" {
  type    = string
}

variable "mariadb-username" {
  type    = string
}

variable "mariadb-password" {
  type    = string
}

variable "VM-Username" {
  type    = string
}

variable "VM-Password" {
  type    = string
}
##
# variable "Storage-Account" {
#   type    = string
# }

# variable "Storage-Account-tier" {
#   type    = string
# }

# variable "Storage-Account-SKU" {
#   type    = string
# }

# variable "Cont-Name" {
#   type    = string
# }