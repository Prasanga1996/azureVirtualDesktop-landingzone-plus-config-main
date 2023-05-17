resource "azurerm_resource_group" "backendServersResourceGroup" {
name = "${var.clientShortHand}-backend-servers"
#This subscriptionLocation is used for every resourceGroup.
location = var.subscriptionLocation
}

resource "azurerm_public_ip" "app01Pip" {
  name                = "${var.clientShortHand}-app01-pip"
  resource_group_name = azurerm_resource_group.backendServersResourceGroup.name
  location            = azurerm_resource_group.backendServersResourceGroup.location
  sku                 = "Standard"
  allocation_method   = "Static"
  tags = {
    "workload"     = var.tagWorkload
    "managedBy"    = var.tagManagedBy
    "environment"  = var.tagEnvironment
    "impact"       = var.tagImpact
  }
}

data "azurerm_subnet" "existing_subnet" {
  name                 = "backend-subnet"
  virtual_network_name = "core-vnet"
  resource_group_name  = "${var.clientShortHand}-core"
}

resource "azurerm_network_interface" "app01Nic" {
  name                = "${var.clientShortHand}-app01-nic"
  resource_group_name = azurerm_resource_group.backendServersResourceGroup.name
  location            = azurerm_resource_group.backendServersResourceGroup.location
  ip_configuration {
    name                          = "ipconfig1"
    #This subnet_id refering to coreNetwork's Subent- backend-subnet.
    subnet_id                     = data.azurerm_subnet.existing_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.app01Pip.id
  }
  tags = {
    "workload"     = var.tagWorkload
    "managedBy"    = var.tagManagedBy
    "environment"  = var.tagEnvironment
    "impact"       = var.tagImpact
  }
}


resource "azurerm_network_interface" "dc01Nic" {
  name                = "${var.clientShortHand}-dc01-nic"
  resource_group_name = azurerm_resource_group.backendServersResourceGroup.name
  location            = azurerm_resource_group.backendServersResourceGroup.location
  ip_configuration {
    name                          = "ipconfig1"
    #This subnet_id refering to coreNetwork's Subent- backend-subnet.
    subnet_id = data.azurerm_subnet.existing_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
  tags = {
    "workload"     = var.tagWorkload
    "managedBy"    = var.tagManagedBy
    "environment"  = var.tagEnvironment
    "impact"       = var.tagImpact
  }
}

resource "azurerm_virtual_machine" "dc01Vm" {
  name                  = upper("${var.clientShortHand}-dc01")
  resource_group_name = azurerm_resource_group.backendServersResourceGroup.name
  location            = azurerm_resource_group.backendServersResourceGroup.location
  network_interface_ids = [azurerm_network_interface.dc01Nic.id]
  vm_size               = "Standard_B2s"
  storage_os_disk {
    name              = "${var.clientShortHand}-dc01-osdisk1"
    create_option     = "FromImage"
  }
  os_profile {
    computer_name  = upper("${var.clientShortHand}-dc01")
    admin_username = "ABTLocalAdmin"
    admin_password = var.adminPassword
  }

  #Check this VM feature on each VM
  os_profile_windows_config {
    enable_automatic_upgrades = false
    provision_vm_agent       = false
  }

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  #Check bydefault Settings
  /*
  boot_diagnostics {
    enabled = false
  }
  */
  
  depends_on = [azurerm_network_interface.dc01Nic]
  tags = {
    "workload"     = var.tagWorkload
    "managedBy"    = var.tagManagedBy
    "environment"  = var.tagEnvironment
    "impact"       = var.tagImpact
  }
}

resource "azurerm_virtual_machine" "app01Vm" {
  name                  = upper("${var.clientShortHand}-app01")
  resource_group_name = azurerm_resource_group.backendServersResourceGroup.name
  location            = azurerm_resource_group.backendServersResourceGroup.location
  vm_size                  = "Standard_B2s"
  os_profile {
    computer_name = upper("${var.clientShortHand}-app01")
    admin_username = "ABTLocalAdmin"
    admin_password = var.adminPassword
  }
  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  storage_os_disk {
    name                 = "${var.clientShortHand}-app01-osdisk"
    create_option        = "FromImage"
  }
  os_profile_windows_config {
    enable_automatic_upgrades = false
     provision_vm_agent = false
  }
  #Check bydefault Settings
  /*
  boot_diagnostics {
    enabled = false
  }
  */
#Write proper properties at same place in all VM Configuration.
  network_interface_ids = [
    azurerm_network_interface.app01Nic.id,
  ]

  tags = {
    "workload"     = var.tagWorkload
    "managedBy"    = var.tagManagedBy
    "environment"  = var.tagEnvironment
    "impact"       = var.tagImpact
  }
depends_on = [azurerm_network_interface.app01Nic]
  
}


