/*
* AlmaLinux 9 Basic VM Module - Provider Configuration
* ==================================================
*
* This file contains the Proxmox provider configuration.
* It supports both token-based and credential-based authentication.
*/

provider "proxmox" {
  # Proxmox VE API endpoint URL
  endpoint  = var.proxmox_server_url
  
  # Skip SSL verification (consider setting to false in production)
  insecure  = var.proxmox_server_ssl_insecure

  # Authentication via API token (preferred method)
  api_token = var.proxmox_api_token
  
  # SSH configuration for SSH-based operations
  ssh {
    agent    = true
    username = var.proxmox_ssh_username
  }

  # Authentication via username/password (alternative method)
  # Uncomment these lines and comment out api_token to use username/password auth
  #username = var.proxmox_web_username
  #password = var.proxmox_user_password
}