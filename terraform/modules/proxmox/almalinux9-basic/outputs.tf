/*
* AlmaLinux 9 Basic VM Module - Outputs
* ====================================
*
* This file defines the outputs from the AlmaLinux 9 VM module
* that can be used by other modules or the root module.
*/

output "vm_id" {
  description = "The ID of the created VM"
  value       = proxmox_virtual_environment_vm.almalinux9-basic.vm_id
}

output "vm_name" {
  description = "The name of the created VM"
  value       = proxmox_virtual_environment_vm.almalinux9-basic.name
}

output "vm_node" {
  description = "The Proxmox node where the VM is located"
  value       = proxmox_virtual_environment_vm.almalinux9-basic.node_name
}

output "ipv4_addresses" {
  description = "All IPv4 addresses assigned to the VM"
  value       = proxmox_virtual_environment_vm.almalinux9-basic.ipv4_addresses
}

output "primary_ipv4_address" {
  description = "The primary IPv4 address of the VM (excluding loopback)"
  value       = length(proxmox_virtual_environment_vm.almalinux9-basic.ipv4_addresses) > 1 ? proxmox_virtual_environment_vm.almalinux9-basic.ipv4_addresses[1][0] : ""
}