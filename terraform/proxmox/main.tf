/*
* AlmaLinux 9 Proxmox Deployment - Main Configuration
* =================================================
*
* This file contains the main Terraform configuration for deploying 
* AlmaLinux 9 VMs on Proxmox VE using the almalinux9-basic module.
*
* Author: Joshua Kunz
* Date: April 20, 2025
* Version: 1.0
*/

# Remote state configuration (uncomment and configure as needed)
# terraform {
#   backend "s3" {
#     bucket         = "terraform-state-bucket"
#     key            = "proxmox/terraform.tfstate"
#     region         = "us-east-1"
#     encrypt        = true
#     dynamodb_table = "terraform-locks"
#   }
# }

# Default provider configuration
provider "proxmox" {
  endpoint  = var.proxmox_server_url
  insecure  = var.proxmox_server_ssl_insecure

  # Token-based authentication (preferred method)
  api_token = var.proxmox_api_token
  ssh {
    agent    = true
    username = var.proxmox_ssh_username
  }

  # Uncomment for credential-based authentication
  # username = var.proxmox_web_username
  # password = var.proxmox_user_password
}

# Local variables for common configurations
locals {
  common_tags = ["terraform-managed", "almalinux9"]
  
  # Standard disk configurations
  standard_disk = [
    { 
      datastore_id = "local-lvm" 
      file_format  = "raw" 
      interface    = "scsi0" 
      size         = "32" 
      ssd          = false 
    }
  ]
  
  # Standard network configuration
  standard_network = [
    {
      bridge    = "vmbr0"
      enabled   = true
      firewall  = false
      model     = "virtio"
      vlan_id   = null
    }
  ]
}