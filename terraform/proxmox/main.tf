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

# Local variables for common configurations
locals {
  # Standard disk configurations
  standard_disk = [
    { 
      datastore_id = "local-lvm" 
      file_format  = "raw" 
      interface    = "scsi0" 
      size         = "16" 
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