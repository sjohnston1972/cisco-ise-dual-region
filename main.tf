# Terraform configuration for dual-region ISE deployment
# This deploys ISE nodes in UK South (Primary) and UK West (Secondary)

# Configure the Azure Provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  required_version = ">= 1.0"
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

#################################################
# UK SOUTH (PRIMARY) RESOURCES
#################################################

# Resource Group for UK South
resource "azurerm_resource_group" "uks_rg" {
  name     = var.uks_resource_group_name
  location = var.uks_location
  
  tags = {
    Environment = "Lab"
    Project     = "ISE-HA"
    Region      = "UK-South"
    Role        = "Primary"
  }
}

# Virtual Network for UK South
resource "azurerm_virtual_network" "uks_vnet" {
  name                = var.uks_vnet_name
  address_space       = [var.uks_vnet_cidr]
  location            = azurerm_resource_group.uks_rg.location
  resource_group_name = azurerm_resource_group.uks_rg.name
  
  tags = {
    Environment = "Lab"
    Project     = "ISE-HA"
  }
}

# Subnet for ISE in UK South
resource "azurerm_subnet" "uks_ise_subnet" {
  name                 = var.uks_subnet_name
  resource_group_name  = azurerm_resource_group.uks_rg.name
  virtual_network_name = azurerm_virtual_network.uks_vnet.name
  address_prefixes     = [var.uks_subnet_cidr]
}

# Network Security Group for UK South ISE
resource "azurerm_network_security_group" "uks_nsg" {
  name                = var.uks_nsg_name
  location            = azurerm_resource_group.uks_rg.location
  resource_group_name = azurerm_resource_group.uks_rg.name
  
  # Allow all inbound (you can restrict this later)
  security_rule {
    name                       = "AllowAllInbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  
  # Allow all outbound (you can restrict this later)
  security_rule {
    name                       = "AllowAllOutbound"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  
  tags = {
    Environment = "Lab"
    Project     = "ISE-HA"
  }
}

# Associate NSG with UK South Subnet
resource "azurerm_subnet_network_security_group_association" "uks_nsg_assoc" {
  subnet_id                 = azurerm_subnet.uks_ise_subnet.id
  network_security_group_id = azurerm_network_security_group.uks_nsg.id
}

# Route Table for UK South
resource "azurerm_route_table" "uks_rt" {
  name                = var.uks_route_table_name
  location            = azurerm_resource_group.uks_rg.location
  resource_group_name = azurerm_resource_group.uks_rg.name
  
  tags = {
    Environment = "Lab"
    Project     = "ISE-HA"
  }
}

# Associate Route Table with UK South Subnet
resource "azurerm_subnet_route_table_association" "uks_rt_assoc" {
  subnet_id      = azurerm_subnet.uks_ise_subnet.id
  route_table_id = azurerm_route_table.uks_rt.id
}

# Public IP for UK South ISE (for management access)
resource "azurerm_public_ip" "uks_ise_pip" {
  name                = "${var.uks_vm_name}-pip"
  location            = azurerm_resource_group.uks_rg.location
  resource_group_name = azurerm_resource_group.uks_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  
  tags = {
    Environment = "Lab"
    Project     = "ISE-HA"
  }
}

# Network Interface for UK South ISE
resource "azurerm_network_interface" "uks_ise_nic" {
  name                = "${var.uks_vm_name}-nic"
  location            = azurerm_resource_group.uks_rg.location
  resource_group_name = azurerm_resource_group.uks_rg.name
  
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.uks_ise_subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.uks_vm_private_ip
    public_ip_address_id          = azurerm_public_ip.uks_ise_pip.id
  }
  
  tags = {
    Environment = "Lab"
    Project     = "ISE-HA"
  }
}

# UK South ISE Virtual Machine
resource "azurerm_linux_virtual_machine" "uks_ise_vm" {
  name                = var.uks_vm_name
  location            = azurerm_resource_group.uks_rg.location
  resource_group_name = azurerm_resource_group.uks_rg.name
  size                = var.vm_size
  admin_username      = var.admin_username
  
  network_interface_ids = [
    azurerm_network_interface.uks_ise_nic.id,
  ]
  
  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }
  
  os_disk {
    name                 = "${var.uks_vm_name}-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb         = 600
  }
  
  plan {
    name      = var.ise_image_sku
    product   = var.ise_image_offer
    publisher = var.ise_image_publisher
  }
  
  source_image_reference {
    publisher = var.ise_image_publisher
    offer     = var.ise_image_offer
    sku       = var.ise_image_sku
    version   = "latest"
  }
  
  tags = {
    Environment = "Lab"
    Project     = "ISE-HA"
    Role        = "Primary"
  }
}

#################################################
# UK WEST (SECONDARY) RESOURCES
#################################################

# Resource Group for UK West
resource "azurerm_resource_group" "ukw_rg" {
  name     = var.ukw_resource_group_name
  location = var.ukw_location
  
  tags = {
    Environment = "Lab"
    Project     = "ISE-HA"
    Region      = "UK-West"
    Role        = "Secondary"
  }
}

# Virtual Network for UK West
resource "azurerm_virtual_network" "ukw_vnet" {
  name                = var.ukw_vnet_name
  address_space       = [var.ukw_vnet_cidr]
  location            = azurerm_resource_group.ukw_rg.location
  resource_group_name = azurerm_resource_group.ukw_rg.name
  
  tags = {
    Environment = "Lab"
    Project     = "ISE-HA"
  }
}

# Subnet for ISE in UK West
resource "azurerm_subnet" "ukw_ise_subnet" {
  name                 = var.ukw_subnet_name
  resource_group_name  = azurerm_resource_group.ukw_rg.name
  virtual_network_name = azurerm_virtual_network.ukw_vnet.name
  address_prefixes     = [var.ukw_subnet_cidr]
}

# Network Security Group for UK West ISE
resource "azurerm_network_security_group" "ukw_nsg" {
  name                = var.ukw_nsg_name
  location            = azurerm_resource_group.ukw_rg.location
  resource_group_name = azurerm_resource_group.ukw_rg.name
  
  # Allow all inbound (you can restrict this later)
  security_rule {
    name                       = "AllowAllInbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  
  # Allow all outbound (you can restrict this later)
  security_rule {
    name                       = "AllowAllOutbound"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  
  tags = {
    Environment = "Lab"
    Project     = "ISE-HA"
  }
}

# Associate NSG with UK West Subnet
resource "azurerm_subnet_network_security_group_association" "ukw_nsg_assoc" {
  subnet_id                 = azurerm_subnet.ukw_ise_subnet.id
  network_security_group_id = azurerm_network_security_group.ukw_nsg.id
}

# Route Table for UK West
resource "azurerm_route_table" "ukw_rt" {
  name                = var.ukw_route_table_name
  location            = azurerm_resource_group.ukw_rg.location
  resource_group_name = azurerm_resource_group.ukw_rg.name
  
  tags = {
    Environment = "Lab"
    Project     = "ISE-HA"
  }
}

# Associate Route Table with UK West Subnet
resource "azurerm_subnet_route_table_association" "ukw_rt_assoc" {
  subnet_id      = azurerm_subnet.ukw_ise_subnet.id
  route_table_id = azurerm_route_table.ukw_rt.id
}

# Public IP for UK West ISE (for management access)
resource "azurerm_public_ip" "ukw_ise_pip" {
  name                = "${var.ukw_vm_name}-pip"
  location            = azurerm_resource_group.ukw_rg.location
  resource_group_name = azurerm_resource_group.ukw_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  
  tags = {
    Environment = "Lab"
    Project     = "ISE-HA"
  }
}

# Network Interface for UK West ISE
resource "azurerm_network_interface" "ukw_ise_nic" {
  name                = "${var.ukw_vm_name}-nic"
  location            = azurerm_resource_group.ukw_rg.location
  resource_group_name = azurerm_resource_group.ukw_rg.name
  
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.ukw_ise_subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.ukw_vm_private_ip
    public_ip_address_id          = azurerm_public_ip.ukw_ise_pip.id
  }
  
  tags = {
    Environment = "Lab"
    Project     = "ISE-HA"
  }
}

# UK West ISE Virtual Machine
resource "azurerm_linux_virtual_machine" "ukw_ise_vm" {
  name                = var.ukw_vm_name
  location            = azurerm_resource_group.ukw_rg.location
  resource_group_name = azurerm_resource_group.ukw_rg.name
  size                = var.vm_size
  admin_username      = var.admin_username
  
  network_interface_ids = [
    azurerm_network_interface.ukw_ise_nic.id,
  ]
  
  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }
  
  os_disk {
    name                 = "${var.ukw_vm_name}-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb         = 600
  }
  
  plan {
    name      = var.ise_image_sku
    product   = var.ise_image_offer
    publisher = var.ise_image_publisher
  }
  
  source_image_reference {
    publisher = var.ise_image_publisher
    offer     = var.ise_image_offer
    sku       = var.ise_image_sku
    version   = "latest"
  }
  
  tags = {
    Environment = "Lab"
    Project     = "ISE-HA"
    Role        = "Secondary"
  }
}
