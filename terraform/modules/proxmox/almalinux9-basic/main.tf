/*
* AlmaLinux 9 Basic VM Module for Proxmox
* =======================================
*
* This Terraform module creates an AlmaLinux 9 VM in Proxmox VE
* from a template created with the accompanying Packer configuration.
*
* Author: Joshua Kunz
* Date: April 20, 2025
* Version: 1.0
*
* Features:
* - Creates a VM from an AlmaLinux 9 template
* - Configures Cloud-Init for initial setup
* - Supports dynamic network and disk configuration
* - Manages startup/shutdown behavior
*/

resource "proxmox_virtual_environment_vm" "almalinux9-basic" {
  # Basic VM identification
  name              = var.vm_name
  vm_id             = var.vm_id
  description       = local.vm_full_description
  tags              = local.vm_all_tags

  # Power state management
  started           = var.vm_start
  on_boot           = var.vm_start_on_boot

  # Target Proxmox node
  node_name         = var.vm_node_name

  cpu {
    cores = var.vm_cpu_cores
    type = "host"
    units = 100
  }

  memory {
    dedicated = var.vm_memory
  }

  # QEMU Guest Agent configuration
  agent {
    enabled         = true
  }

  # VM startup/shutdown order configuration
  startup {
    order           = var.vm_startup_order
    up_delay        = var.vm_up_down_delay
    down_delay      = var.vm_up_down_delay
  }

  # VM template source configuration
  clone {
    datastore_id    = var.vm_datastore_id
    node_name       = var.vm_template_node_name
    vm_id           = var.vm_template_id
  }

  # Cloud-Init configuration for initial setup
  initialization {
    interface       = var.vm_ci_interface

    # Network configuration
    ip_config {
      ipv4 {
        address     = var.vm_ip_address
        gateway     = var.vm_ip_address == "dhcp" ? null : var.vm_ip_gateway
      }
    }

    # Service account configuration
    user_account {
      username      = var.vm_sa_user_name
      password      = var.vm_sa_user_password
      keys          = var.vm_sa_user_ssh_keys
    }
  }

  # Keyboard layout for VM console
  keyboard_layout   = "de-ch"

  # Dynamic network device configuration
  dynamic "network_device" {
    for_each    = [for nd in var.vm_network_devices: {
      bridge        = nd.bridge  
      enabled       = nd.enabled  
      firewall      = nd.firewall  
      model         = nd.model
      vlan_id       = nd.vlan_id 
    }]  
    content {
      bridge        = network_device.value.bridge
      enabled       = network_device.value.enabled
      firewall      = network_device.value.firewall
      model         = network_device.value.model
      vlan_id       = network_device.value.vlan_id
    }
  }

  # Dynamic disk configuration
  dynamic "disk" {
    for_each    = [for d in var.vm_disks: {
      datastore_id  = d.datastore_id
      file_format   = d.file_format
      interface     = d.interface
      size          = d.size
      ssd           = d.ssd
    }]  
    content {
      datastore_id  = disk.value.datastore_id
      file_format   = disk.value.file_format
      interface     = disk.value.interface
      size          = disk.value.size
      ssd           = disk.value.ssd
    }
  }
}