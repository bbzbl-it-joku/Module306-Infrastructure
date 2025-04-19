/*
* AlmaLinux 9 Proxmox Template Builder
* ====================================
*
* This Packer configuration creates an AlmaLinux 9 VM template on Proxmox
* using a kickstart file hosted on GitHub to enable cross-network deployments.
*
* Author: Joshua Kunz
* Date: April 20, 2025
* Version: 1.0
*
* This configuration:
* - Uses GitHub-hosted kickstart files instead of the Packer HTTP server
* - Configures UEFI boot for modern system compatibility
* - Sets up Cloud-Init for VM templating
* - Includes proper cleanup for template preparation
*/

packer {
  required_version = ">= 1.8.0"
  
  required_plugins {
    proxmox = {
      version = ">= 1.1.2"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

// Import variable declarations
locals {
  // Build timestamp for template versioning
  build_timestamp = formatdate("YYYYMMDDhhmmss", timestamp())
  
  // Template description with timestamp
  template_description = "AlmaLinux 9 Minimal UEFI Template. Built ${local.build_timestamp}"
  
  // Complete GitHub URL for kickstart
  kickstart_url = "${var.github_raw_url}/files/kickstart/ks.cfg"
}

// Resource Definition for the VM Template
source "proxmox-iso" "almalinux9" {
  /*
   * Proxmox Connection Settings
   * --------------------------
   * Configure authentication and connection parameters for Proxmox VE API
   */
  proxmox_url              = var.proxmox_api_url
  username                 = var.proxmox_api_token_id
  token                    = var.proxmox_api_token_secret
  insecure_skip_tls_verify = var.proxmox_skip_tls_verify

  /*
   * VM General Settings
   * ------------------
   * Basic VM identification and placement settings
   */
  node                  = var.proxmox_node
  vm_id                 = var.vm_id
  vm_name               = var.vm_name
  template_description  = local.template_description

  /*
   * VM OS Settings
   * -------------
   * Installation media and boot settings
   */
  iso_file         = var.iso_file
  iso_storage_pool = var.iso_storage_pool
  unmount_iso      = true
  
  /*
   * VM System Settings
   * -----------------
   * Hardware and system configuration
   */
  qemu_agent = true

  // UEFI boot configuration
  bios = "ovmf"
  efi_config {
    efi_storage_pool  = var.efi_storage_pool
    efi_type          = "4m"
    pre_enrolled_keys = true
  }

  /*
   * VM Storage Settings
   * ------------------
   * Disk and storage configuration
   */
  scsi_controller = "virtio-scsi-pci"

  disks {
    disk_size           = var.disk_size
    storage_pool        = var.storage_pool
    type                = "scsi"
  }

  /*
   * VM Hardware Settings
   * -------------------
   * CPU and memory configuration
   */
  cores     = var.vm_cores
  cpu_type  = var.cpu_type
  memory    = var.vm_memory
  sockets   = "1"

  /*
   * VM Network Settings
   * ------------------
   * Network adapter configuration
   */
  network_adapters {
    model    = "virtio"
    bridge   = var.network_bridge
    firewall = "false"
  }

  /*
   * Boot and Provisioning Settings
   * -----------------------------
   * Boot command and connection settings for provisioning
   */
  // Boot command using GitHub-hosted kickstart instead of HTTP server
  boot_command = [
    "<up><wait>e<wait><down><wait><down><wait><end>",
    " inst.text",
    " inst.ks=${local.kickstart_url} ",
    "<wait><F10>"
  ]
  boot_wait = "10s"

  // This directory is required by Packer but won't be used by the VM
  http_directory = "files/kickstart"

  /*
   * SSH Settings
   * -----------
   * SSH connection details for provisioning
   */
  ssh_username = "root"
  ssh_password = var.vm_root_pw
  ssh_timeout  = "30m"
}

/*
 * Build Definition
 * --------------
 * Build process and provisioning steps
 */
build {
  name    = "almalinux9-template"
  sources = ["source.proxmox-iso.almalinux9"]

  /*
   * Provisioning Step 1: Copy Cloud-Init setup script
   * -----------------------------------------------
   * Transfer the setup script to the VM
   */
  provisioner "file" {
    source      = "scripts/setup-cloud-init.sh"
    destination = "/tmp/setup-cloud-init.sh"
  }

  /*
   * Provisioning Step 2: Execute Cloud-Init setup
   * -------------------------------------------
   * Configure Cloud-Init and prepare for templating
   */
  provisioner "shell" {
    inline = [
      "chmod +x /tmp/setup-cloud-init.sh",
      "/tmp/setup-cloud-init.sh"
    ]
  }

  /*
   * Provisioning Step 3: System cleanup
   * ---------------------------------
   * Clean up the system to prepare for templating
   */
  provisioner "shell" {
    script = "scripts/cleanup.sh"
  }

  /*
   * Post-Processor
   * ------------
   * Actions to perform after successful build
   */
  post-processor "shell-local" {
    inline = [
      "echo 'Build completed successfully!'",
      "echo 'Template Name: ${var.vm_name}'",
      "echo 'Template ID: ${var.vm_id}'"
    ]
  }
}