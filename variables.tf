# Variables for ISE Terraform Deployment
# This file defines all the configurable parameters

#################################################
# GLOBAL VARIABLES
#################################################

variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}

variable "admin_username" {
  description = "Admin username for ISE VMs"
  type        = string
  default     = "iseadmin"
}

variable "ssh_public_key" {
  description = "SSH public key for VM access"
  type        = string
}

variable "vm_size" {
  description = "Azure VM size for ISE nodes"
  type        = string
  default     = "Standard_D8s_v4"
}

# ISE Marketplace Image Details
variable "ise_image_publisher" {
  description = "ISE image publisher"
  type        = string
  default     = "cisco"
}

variable "ise_image_offer" {
  description = "ISE image offer"
  type        = string
  default     = "cisco-ise-virtual"
}

variable "ise_image_sku" {
  description = "ISE image SKU (version)"
  type        = string
  default     = "cisco-ise_3_3"
}

#################################################
# UK SOUTH (PRIMARY) VARIABLES
#################################################

variable "uks_location" {
  description = "Azure region for UK South resources"
  type        = string
  default     = "uksouth"
}

variable "uks_resource_group_name" {
  description = "Resource Group name for UK South"
  type        = string
  default     = "rg-ise-pri-uks"
}

variable "uks_vnet_name" {
  description = "VNet name for UK South"
  type        = string
  default     = "vnet-ise-uks"
}

variable "uks_vnet_cidr" {
  description = "VNet CIDR for UK South"
  type        = string
  default     = "10.10.0.0/16"
}

variable "uks_subnet_name" {
  description = "Subnet name for ISE in UK South"
  type        = string
  default     = "snet-ise-uks"
}

variable "uks_subnet_cidr" {
  description = "Subnet CIDR for UK South"
  type        = string
  default     = "10.10.1.0/24"
}

variable "uks_nsg_name" {
  description = "NSG name for UK South"
  type        = string
  default     = "nsg-ise-uks"
}

variable "uks_route_table_name" {
  description = "Route Table name for UK South"
  type        = string
  default     = "rt-ise-uks"
}

variable "uks_vm_name" {
  description = "VM name for UK South ISE"
  type        = string
  default     = "ise-pri-uks"
}

variable "uks_vm_private_ip" {
  description = "Static private IP for UK South ISE VM"
  type        = string
  default     = "10.10.1.10"
}

#################################################
# UK WEST (SECONDARY) VARIABLES
#################################################

variable "ukw_location" {
  description = "Azure region for UK West resources"
  type        = string
  default     = "ukwest"
}

variable "ukw_resource_group_name" {
  description = "Resource Group name for UK West"
  type        = string
  default     = "rg-ise-sec-ukw"
}

variable "ukw_vnet_name" {
  description = "VNet name for UK West"
  type        = string
  default     = "vnet-ise-ukw"
}

variable "ukw_vnet_cidr" {
  description = "VNet CIDR for UK West"
  type        = string
  default     = "10.20.0.0/16"
}

variable "ukw_subnet_name" {
  description = "Subnet name for ISE in UK West"
  type        = string
  default     = "snet-ise-ukw"
}

variable "ukw_subnet_cidr" {
  description = "Subnet CIDR for UK West"
  type        = string
  default     = "10.20.1.0/24"
}

variable "ukw_nsg_name" {
  description = "NSG name for UK West"
  type        = string
  default     = "nsg-ise-ukw"
}

variable "ukw_route_table_name" {
  description = "Route Table name for UK West"
  type        = string
  default     = "rt-ise-ukw"
}

variable "ukw_vm_name" {
  description = "VM name for UK West ISE"
  type        = string
  default     = "ise-sec-ukw"
}

variable "ukw_vm_private_ip" {
  description = "Static private IP for UK West ISE VM"
  type        = string
  default     = "10.20.1.10"
}

#################################################
# US EAST (TERTIARY) VARIABLES
#################################################

variable "use_location" {
  description = "Azure region for US East resources"
  type        = string
  default     = "eastus"
}

variable "use_resource_group_name" {
  description = "Resource Group name for US East"
  type        = string
  default     = "rg-ise-ter-use"
}

variable "use_vnet_name" {
  description = "VNet name for US East"
  type        = string
  default     = "vnet-ise-use"
}

variable "use_vnet_cidr" {
  description = "VNet CIDR for US East"
  type        = string
  default     = "10.30.0.0/16"
}

variable "use_subnet_name" {
  description = "Subnet name for ISE in US East"
  type        = string
  default     = "snet-ise-use"
}

variable "use_subnet_cidr" {
  description = "Subnet CIDR for US East"
  type        = string
  default     = "10.30.1.0/24"
}

variable "use_nsg_name" {
  description = "NSG name for US East"
  type        = string
  default     = "nsg-ise-use"
}

variable "use_route_table_name" {
  description = "Route Table name for US East"
  type        = string
  default     = "rt-ise-use"
}

variable "use_vm_name" {
  description = "VM name for US East ISE"
  type        = string
  default     = "ise-ter-use"
}

variable "use_vm_private_ip" {
  description = "Static private IP for US East ISE VM"
  type        = string
  default     = "10.30.1.10"
}

#################################################
# US WEST (QUATERNARY) VARIABLES
#################################################

variable "usw_location" {
  description = "Azure region for US West resources"
  type        = string
  default     = "westus"
}

variable "usw_resource_group_name" {
  description = "Resource Group name for US West"
  type        = string
  default     = "rg-ise-qua-usw"
}

variable "usw_vnet_name" {
  description = "VNet name for US West"
  type        = string
  default     = "vnet-ise-usw"
}

variable "usw_vnet_cidr" {
  description = "VNet CIDR for US West"
  type        = string
  default     = "10.40.0.0/16"
}

variable "usw_subnet_name" {
  description = "Subnet name for ISE in US West"
  type        = string
  default     = "snet-ise-usw"
}

variable "usw_subnet_cidr" {
  description = "Subnet CIDR for US West"
  type        = string
  default     = "10.40.1.0/24"
}

variable "usw_nsg_name" {
  description = "NSG name for US West"
  type        = string
  default     = "nsg-ise-usw"
}

variable "usw_route_table_name" {
  description = "Route Table name for US West"
  type        = string
  default     = "rt-ise-usw"
}

variable "usw_vm_name" {
  description = "VM name for US West ISE"
  type        = string
  default     = "ise-qua-usw"
}

variable "usw_vm_private_ip" {
  description = "Static private IP for US West ISE VM"
  type        = string
  default     = "10.40.1.10"
}
