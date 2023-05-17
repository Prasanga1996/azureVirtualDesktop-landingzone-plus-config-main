resource "azurerm_resource_group" "core_resource_group" {
  name     = "${var.clientShortHand}-core"
  location = var.subscriptionLocation

}

resource "azurerm_network_security_group" "backendNsg" {
  name                = "backend-nsg"
  location            = azurerm_resource_group.core_resource_group.location
  resource_group_name = azurerm_resource_group.core_resource_group.name
  depends_on = [ 
    azurerm_resource_group.core_resource_group,
   ]

  security_rule {
    name                       = "Allow-ABT-RDP"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "61.69.75.194/32"
    destination_address_prefix = "*"
  }

  tags = {
    "workload"   = var.tagWorkload
    "managedBy"  = var.tagManagedBy
    "environment" = var.tagEnvironment
    "impact"     = var.tagImpact
  }
}

resource "azurerm_network_security_group" "frontendNsg" {
  name                = "frontend-nsg"
  location            = azurerm_resource_group.core_resource_group.location
  resource_group_name = azurerm_resource_group.core_resource_group.name
  depends_on = [ 
    azurerm_resource_group.core_resource_group,
   ]

  security_rule {
    name                       = "Allow-ABT-RDP"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "61.69.75.194/32"
    destination_address_prefix = "*"
  }

  tags = {
    "workload"   = var.tagWorkload
    "managedBy"  = var.tagManagedBy
    "environment" = var.tagEnvironment
    "impact"     = var.tagImpact
  }
}

resource "azurerm_network_security_group" "avdNsg" {
  name                = "avd-nsg"
  location            = azurerm_resource_group.core_resource_group.location
  resource_group_name = azurerm_resource_group.core_resource_group.name
  depends_on = [ 
    azurerm_resource_group.core_resource_group,
   ]

  security_rule {
    name                       = "Allow-ABT-RDP"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "61.69.75.194/32"
    destination_address_prefix = "*"
  }

  tags = {
    "workload"   = var.tagWorkload
    "managedBy"  = var.tagManagedBy
    "environment" = var.tagEnvironment
    "impact"     = var.tagImpact
  }
}

resource "azurerm_virtual_network" "coreVNet" {
  name                = "core-vnet"
  resource_group_name = azurerm_resource_group.core_resource_group.name
  location            = azurerm_resource_group.core_resource_group.location
  address_space       = ["10.254.0.0/16"]
  #Check for these values whether they will be enabled by default or not.
  #enable_vm_protection = false
  #enable_ddos_protection = false
  tags = {
    "workload"   = var.tagWorkload
    "managedBy"  = var.tagManagedBy
    "environment" = var.tagEnvironment
    "impact"     = var.tagImpact
  }

  depends_on = [
    azurerm_network_security_group.backendNsg,
    azurerm_network_security_group.frontendNsg,
    azurerm_network_security_group.avdNsg,
    azurerm_resource_group.core_resource_group,
  ]
}

resource "azurerm_subnet" "backend-subnet" {
  name = "backend-subnet"
  resource_group_name = azurerm_resource_group.core_resource_group.name
  virtual_network_name = azurerm_virtual_network.coreVNet.name
  address_prefixes = [ "10.254.0.0/24" ]
  #In Service Endpoints, locations are not setup.
  service_endpoints = [ "Microsoft.Storage" ]
  private_endpoint_network_policies_enabled = true
  #enforce_private_link_endpoint_network_policies = true

}

resource "azurerm_subnet" "frontend-subnet" {
  name = "frontend-subnet"
  resource_group_name = azurerm_resource_group.core_resource_group.name
  virtual_network_name = azurerm_virtual_network.coreVNet.name
  address_prefixes = [ "10.254.1.0/24" ]
}

resource "azurerm_subnet" "avd-subnet" {
  name = "avd-subnet"
  resource_group_name = azurerm_resource_group.core_resource_group.name
  virtual_network_name = azurerm_virtual_network.coreVNet.name
  address_prefixes = [ "10.254.2.0/24" ]
}

resource "azurerm_subnet_network_security_group_association" "backendNsgtobackend-subnet" {
  subnet_id                 = azurerm_subnet.backend-subnet.id
  network_security_group_id = azurerm_network_security_group.backendNsg.id
}

resource "azurerm_subnet_network_security_group_association" "frontendNsgtofrontend-subnet" {
  subnet_id                 = azurerm_subnet.frontend-subnet.id
  network_security_group_id = azurerm_network_security_group.frontendNsg.id
}

resource "azurerm_subnet_network_security_group_association" "avdNsgtoavd-subnet" {
  subnet_id                 = azurerm_subnet.avd-subnet.id
  network_security_group_id = azurerm_network_security_group.avdNsg.id
}

resource "azurerm_storage_account" "backenddiagstg" {
  name                     = lower("${var.clientShortHand}backenddiagstg")
  location                 = azurerm_resource_group.core_resource_group.location
  resource_group_name = azurerm_resource_group.core_resource_group.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind = "StorageV2"
  depends_on = [ 
    azurerm_resource_group.core_resource_group,
   ]
  tags = {
    "workload"   = var.tagWorkload
    "managedBy"  = var.tagManagedBy
    "environment" = var.tagEnvironment
    "impact"     = var.tagImpact
  }
}

