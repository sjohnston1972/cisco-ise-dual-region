# Variables for ISE Terraform Deployment
# This file defines all the configurable parameters

#################################################
# GLOBAL VARIABLES
#################################################

variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string

  validation {
    condition     = can(regex("^[0-9a-fA-F]{8}-([0-9a-fA-F]{4}-){3}[0-9a-fA-F]{12}$", var.subscription_id))
    error_message = "subscription_id must be a GUID (xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx)."
  }
}

variable "admin_username" {
  description = "Admin username for ISE VMs"
  type        = string
  default     = "iseadmin"
}

variable "ssh_public_key" {
  description = "SSH public key for VM access"
  type        = string

  validation {
    condition     = can(regex("^(ssh-rsa|ssh-ed25519|ecdsa-sha2-\\S+) \\S+", var.ssh_public_key))
    error_message = "ssh_public_key must be an OpenSSH public key (e.g. 'ssh-rsa AAAA... comment')."
  }
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

variable "ise_image_version" {
  description = "Exact ISE marketplace image version to pin (avoid 'latest' so both HA nodes deploy the same build). Discover available versions with: az vm image list --publisher cisco --offer cisco-ise-virtual --sku cisco-ise_3_3 --all -o table"
  type        = string
  default     = "3.3.430"
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
