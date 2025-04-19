/*
* AlmaLinux 9 Basic VM Module - Terraform Configuration
* ===================================================
*
* This file contains the Terraform configuration for the module,
* including required providers and versions.
*/

terraform {
  # Minimum required Terraform version
  required_version = ">= 1.0.0"
  
  # Required provider declarations
  required_providers {
    # BPG's Proxmox provider is used for Proxmox VE API integration
    proxmox = {
      source  = "bpg/proxmox"
      version = ">=0.32.0"
    }
  }
}