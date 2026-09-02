# Outputs - Information displayed after Terraform deployment

# Public IPs are opt-in (var.enable_public_ip, default false) - see #9.
# These locals resolve to a friendly placeholder instead of erroring when
# no public IP was created.
locals {
  uks_ise_public_ip = try(azurerm_public_ip.uks_ise_pip[0].ip_address, "none (enable_public_ip=false)")
  ukw_ise_public_ip = try(azurerm_public_ip.ukw_ise_pip[0].ip_address, "none (enable_public_ip=false)")
}

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
  description = "UK South ISE Public IP (for management access, if enable_public_ip=true)"
  value       = local.uks_ise_public_ip
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
  description = "UK West ISE Public IP (for management access, if enable_public_ip=true)"
  value       = local.ukw_ise_public_ip
}

output "ukw_ise_vm_name" {
  description = "UK West ISE VM Name"
  value       = azurerm_linux_virtual_machine.ukw_ise_vm.name
}

#################################################
# DEPLOYMENT SUMMARY
#################################################

output "deployment_summary" {
  description = "Deployment Summary"
  value       = <<-EOT
  
  ╔════════════════════════════════════════════════════════════════╗
  ║           ISE DUAL-REGION DEPLOYMENT COMPLETE                  ║
  ╚════════════════════════════════════════════════════════════════╝
  
  PRIMARY NODE (UK SOUTH):
  -------------------------
  VM Name:        ${azurerm_linux_virtual_machine.uks_ise_vm.name}
  Private IP:     ${azurerm_network_interface.uks_ise_nic.private_ip_address}
  Public IP:      ${local.uks_ise_public_ip}

  SECONDARY NODE (UK WEST):
  -------------------------
  VM Name:        ${azurerm_linux_virtual_machine.ukw_ise_vm.name}
  Private IP:     ${azurerm_network_interface.ukw_ise_nic.private_ip_address}
  Public IP:      ${local.ukw_ise_public_ip}

  ╔════════════════════════════════════════════════════════════════╗
  ║                     NEXT STEPS                                 ║
  ╚════════════════════════════════════════════════════════════════╝

  1. Wait 15-20 minutes for ISE to fully boot

  2. Configure VNet Peering between regions:
     - UK South VNet ID: ${azurerm_virtual_network.uks_vnet.id}
     - UK West VNet ID:  ${azurerm_virtual_network.ukw_vnet.id}

  3. Access ISE Setup Wizard (requires enable_public_ip=true, or reach the
     private IPs above via VPN/Bastion/peering):
     - Primary:   https://${local.uks_ise_public_ip}
     - Secondary: https://${local.ukw_ise_public_ip}
     - Username: ${var.admin_username}
     - Set passwords during initial setup

  4. Configure Primary node first, then register Secondary

  EOT
}
