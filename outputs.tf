# Outputs - Information displayed after Terraform deployment

#################################################
# UK SOUTH (PRIMARY) OUTPUTS
#################################################

output "uks_resource_group_name" {
  description = "UK South Resource Group Name"
  value       = azurerm_resource_group.uks_rg.name
}

output "uks_vnet_name" {
  description = "UK South VNet Name"
  value       = azurerm_virtual_network.uks_vnet.name
}

output "uks_vnet_id" {
  description = "UK South VNet ID (needed for peering)"
  value       = azurerm_virtual_network.uks_vnet.id
}

output "uks_ise_private_ip" {
  description = "UK South ISE Private IP"
  value       = azurerm_network_interface.uks_ise_nic.private_ip_address
}

output "uks_ise_public_ip" {
  description = "UK South ISE Public IP (for management access)"
  value       = azurerm_public_ip.uks_ise_pip.ip_address
}

output "uks_ise_vm_name" {
  description = "UK South ISE VM Name"
  value       = azurerm_linux_virtual_machine.uks_ise_vm.name
}

#################################################
# UK WEST (SECONDARY) OUTPUTS
#################################################

output "ukw_resource_group_name" {
  description = "UK West Resource Group Name"
  value       = azurerm_resource_group.ukw_rg.name
}

output "ukw_vnet_name" {
  description = "UK West VNet Name"
  value       = azurerm_virtual_network.ukw_vnet.name
}

output "ukw_vnet_id" {
  description = "UK West VNet ID (needed for peering)"
  value       = azurerm_virtual_network.ukw_vnet.id
}

output "ukw_ise_private_ip" {
  description = "UK West ISE Private IP"
  value       = azurerm_network_interface.ukw_ise_nic.private_ip_address
}

output "ukw_ise_public_ip" {
  description = "UK West ISE Public IP (for management access)"
  value       = azurerm_public_ip.ukw_ise_pip.ip_address
}

output "ukw_ise_vm_name" {
  description = "UK West ISE VM Name"
  value       = azurerm_linux_virtual_machine.ukw_ise_vm.name
}

#################################################
# US EAST (TERTIARY) OUTPUTS
#################################################

output "use_resource_group_name" {
  description = "US East Resource Group Name"
  value       = azurerm_resource_group.use_rg.name
}

output "use_vnet_name" {
  description = "US East VNet Name"
  value       = azurerm_virtual_network.use_vnet.name
}

output "use_vnet_id" {
  description = "US East VNet ID (needed for peering)"
  value       = azurerm_virtual_network.use_vnet.id
}

output "use_ise_private_ip" {
  description = "US East ISE Private IP"
  value       = azurerm_network_interface.use_ise_nic.private_ip_address
}

output "use_ise_public_ip" {
  description = "US East ISE Public IP (for management access)"
  value       = azurerm_public_ip.use_ise_pip.ip_address
}

output "use_ise_vm_name" {
  description = "US East ISE VM Name"
  value       = azurerm_linux_virtual_machine.use_ise_vm.name
}

#################################################
# US WEST (QUATERNARY) OUTPUTS
#################################################

output "usw_resource_group_name" {
  description = "US West Resource Group Name"
  value       = azurerm_resource_group.usw_rg.name
}

output "usw_vnet_name" {
  description = "US West VNet Name"
  value       = azurerm_virtual_network.usw_vnet.name
}

output "usw_vnet_id" {
  description = "US West VNet ID (needed for peering)"
  value       = azurerm_virtual_network.usw_vnet.id
}

output "usw_ise_private_ip" {
  description = "US West ISE Private IP"
  value       = azurerm_network_interface.usw_ise_nic.private_ip_address
}

output "usw_ise_public_ip" {
  description = "US West ISE Public IP (for management access)"
  value       = azurerm_public_ip.usw_ise_pip.ip_address
}

output "usw_ise_vm_name" {
  description = "US West ISE VM Name"
  value       = azurerm_linux_virtual_machine.usw_ise_vm.name
}

#################################################
# DEPLOYMENT SUMMARY
#################################################

output "deployment_summary" {
  description = "Deployment Summary"
  value = <<-EOT

  ╔════════════════════════════════════════════════════════════════╗
  ║           ISE QUAD-REGION DEPLOYMENT COMPLETE                  ║
  ╚════════════════════════════════════════════════════════════════╝

  PRIMARY NODE (UK SOUTH):
  -------------------------
  VM Name:        ${azurerm_linux_virtual_machine.uks_ise_vm.name}
  Private IP:     ${azurerm_network_interface.uks_ise_nic.private_ip_address}
  Public IP:      ${azurerm_public_ip.uks_ise_pip.ip_address}
  Management URL: https://${azurerm_public_ip.uks_ise_pip.ip_address}

  SECONDARY NODE (UK WEST):
  -------------------------
  VM Name:        ${azurerm_linux_virtual_machine.ukw_ise_vm.name}
  Private IP:     ${azurerm_network_interface.ukw_ise_nic.private_ip_address}
  Public IP:      ${azurerm_public_ip.ukw_ise_pip.ip_address}
  Management URL: https://${azurerm_public_ip.ukw_ise_pip.ip_address}

  TERTIARY NODE (US EAST):
  -------------------------
  VM Name:        ${azurerm_linux_virtual_machine.use_ise_vm.name}
  Private IP:     ${azurerm_network_interface.use_ise_nic.private_ip_address}
  Public IP:      ${azurerm_public_ip.use_ise_pip.ip_address}
  Management URL: https://${azurerm_public_ip.use_ise_pip.ip_address}

  QUATERNARY NODE (US WEST):
  -------------------------
  VM Name:        ${azurerm_linux_virtual_machine.usw_ise_vm.name}
  Private IP:     ${azurerm_network_interface.usw_ise_nic.private_ip_address}
  Public IP:      ${azurerm_public_ip.usw_ise_pip.ip_address}
  Management URL: https://${azurerm_public_ip.usw_ise_pip.ip_address}

  ╔════════════════════════════════════════════════════════════════╗
  ║                     NEXT STEPS                                 ║
  ╚════════════════════════════════════════════════════════════════╝

  1. Wait 15-20 minutes for ISE to fully boot

  2. Configure VNet Peering between all regions:
     - UK South VNet ID: ${azurerm_virtual_network.uks_vnet.id}
     - UK West VNet ID:  ${azurerm_virtual_network.ukw_vnet.id}
     - US East VNet ID:  ${azurerm_virtual_network.use_vnet.id}
     - US West VNet ID:  ${azurerm_virtual_network.usw_vnet.id}

  3. Access ISE Setup Wizard:
     - Primary:     https://${azurerm_public_ip.uks_ise_pip.ip_address}
     - Secondary:   https://${azurerm_public_ip.ukw_ise_pip.ip_address}
     - Tertiary:    https://${azurerm_public_ip.use_ise_pip.ip_address}
     - Quaternary:  https://${azurerm_public_ip.usw_ise_pip.ip_address}
     - Username: ${var.admin_username}
     - Set passwords during initial setup

  4. Configure Primary node first, then register Secondary, Tertiary, and Quaternary

  EOT
}
