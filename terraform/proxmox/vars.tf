/*
* AlmaLinux 9 Proxmox Deployment - Variables
* =======================================
*
* This file contains variable declarations for the root module.
* Values are provided in terraform.tfvars or via environment variables.
*/

//----------------------------------------------------------------------
// Proxmox Connection Variables
//----------------------------------------------------------------------

variable "proxmox_server_url" {
    description = "The URL of the Proxmox server that Terraform connects to (e.g., https://proxmox.example.com:8006)"
    type = string
}

variable "proxmox_web_username" {
    description = "The username for Proxmox authentication when using credentials (e.g., root@pam)"
    type = string
}

variable "proxmox_ssh_username" {
    description = "The SSH username for Proxmox when using API token authentication"
    type = string
}

variable "proxmox_user_password" {
    description = "The password for Proxmox authentication when using credentials"
    type = string
    sensitive = true
    default = ""
}

variable "proxmox_api_token" {
    description = "The API token for Proxmox authentication when using token-based auth"
    type = string
    sensitive = true
}

variable "proxmox_server_ssl_insecure" {
    description = "Whether to skip SSL certificate validation for Proxmox connection (false recommended for production)"
    type = bool
}

//----------------------------------------------------------------------
// VM User Configuration Variables
//----------------------------------------------------------------------

variable "vm_sa_user_password" {
    description = "The password for the service account to be created in VMs"
    type = string
    sensitive = true
}

variable "vm_sa_user_ssh_keys" {
    description = "List of SSH public keys to authorize for the service account in VMs"
    type = list(string)
    sensitive = true
}

//----------------------------------------------------------------------
// Global Configuration Variables
//----------------------------------------------------------------------

variable "environment" {
    description = "Deployment environment (dev, test, prod)"
    type = string
    default = "dev"
    validation {
        condition = contains(["dev", "test", "prod"], var.environment)
        error_message = "Environment must be one of: dev, test, prod."
    }
}

variable "owner" {
    description = "Owner or responsible team for these resources"
    type = string
    default = "IT Operations"
}

variable "project" {
    description = "Project name for resource tagging and organization"
    type = string
    default = "Infrastructure"
}