/*
* Development Environment AlmaLinux 9 VM Deployments
* ===============================================
*
* This file defines development environment VMs based on AlmaLinux 9.
* Each VM is deployed using the almalinux9-basic module.
*
* Naming convention: 
* - devtfXX: Development Terraform VMs (XX is a sequential number)
*/

#----------------------------------------------------------------------
# Dev VM 01 - Developer workstation
#----------------------------------------------------------------------
module "devtf01" {
    source = "../../modules/proxmox/almalinux9-basic"

    # Proxmox connection parameters (inherited from root module)
    proxmox_server_url          = var.proxmox_server_url
    proxmox_web_username        = var.proxmox_web_username
    proxmox_ssh_username        = var.proxmox_ssh_username
    proxmox_user_password       = var.proxmox_user_password
    proxmox_api_token           = var.proxmox_api_token
    proxmox_server_ssl_insecure = var.proxmox_server_ssl_insecure

    # Basic VM configuration
    vm_name                     = "devtf01"
    vm_description              = "Developer workstation environment"
    vm_tags                     = concat(["dev", "workstation"], local.common_tags)
    vm_id                       = 2001
    
    # Template configuration
    vm_ci_interface             = "scsi1"
    vm_template_id              = 9001
    
    # Hardware configuration - more resources for development work
    vm_cores                    = 4
    vm_memory                   = 8192
    
    # Network configuration
    vm_ip_address               = "dhcp"
    
    # Enhanced disk configuration for development
    vm_disks                    = [
      { 
        datastore_id  = "local-lvm" 
        file_format   = "raw" 
        interface     = "scsi0" 
        size          = "64" 
        ssd           = true
      }
    ]
    
    # Power management
    vm_start                    = true
    vm_start_on_boot            = true
    
    # Authentication and user configuration
    vm_sa_user_password         = var.vm_sa_user_password
    vm_sa_user_ssh_keys         = var.vm_sa_user_ssh_keys
}

#----------------------------------------------------------------------
# Dev VM 02 - Integration testing environment
#----------------------------------------------------------------------
module "devtf02" {
    source = "../../modules/proxmox/almalinux9-basic"

    # Proxmox connection parameters (inherited from root module)
    proxmox_server_url          = var.proxmox_server_url
    proxmox_web_username        = var.proxmox_web_username
    proxmox_ssh_username        = var.proxmox_ssh_username
    proxmox_user_password       = var.proxmox_user_password
    proxmox_api_token           = var.proxmox_api_token
    proxmox_server_ssl_insecure = var.proxmox_server_ssl_insecure

    # Basic VM configuration
    vm_name                     = "devtf02"
    vm_description              = "Integration testing environment"
    vm_tags                     = concat(["dev", "integration"], local.common_tags)
    vm_id                       = 2002
    
    # Template configuration
    vm_ci_interface             = "scsi1"
    vm_template_id              = 9001
    
    # Hardware configuration
    vm_cores                    = 2
    vm_memory                   = 4096
    
    # Network configuration
    vm_ip_address               = "dhcp"
    
    # Standard disk configuration
    vm_disks                    = local.standard_disk
    
    # Power management - only powered on when needed
    vm_start                    = false
    vm_start_on_boot            = false
    
    # Authentication and user configuration
    vm_sa_user_password         = var.vm_sa_user_password
    vm_sa_user_ssh_keys         = var.vm_sa_user_ssh_keys
}

#----------------------------------------------------------------------
# Dev VM 03 - CI/CD Pipeline server
#----------------------------------------------------------------------
module "devtf03" {
    source = "../../modules/proxmox/almalinux9-basic"

    # Proxmox connection parameters (inherited from root module)
    proxmox_server_url          = var.proxmox_server_url
    proxmox_web_username        = var.proxmox_web_username
    proxmox_ssh_username        = var.proxmox_ssh_username
    proxmox_user_password       = var.proxmox_user_password
    proxmox_api_token           = var.proxmox_api_token
    proxmox_server_ssl_insecure = var.proxmox_server_ssl_insecure

    # Basic VM configuration
    vm_name                     = "devtf03"
    vm_description              = "CI/CD Pipeline server"
    vm_tags                     = concat(["dev", "cicd"], local.common_tags)
    vm_id                       = 2003
    
    # Template configuration
    vm_ci_interface             = "scsi1"
    vm_template_id              = 9001
    
    # Hardware configuration - need more resources for CI/CD
    vm_cores                    = 4
    vm_memory                   = 8192
    
    # Network configuration
    vm_ip_address               = "dhcp"
    
    # Enhanced disk configuration for CI/CD
    vm_disks                    = [
      { 
        datastore_id  = "local-lvm" 
        file_format   = "raw" 
        interface     = "scsi0" 
        size          = "100" 
        ssd           = true
      }
    ]
    
    # Power management - always on for CI/CD availability
    vm_start                    = true
    vm_start_on_boot            = true
    
    # Authentication and user configuration
    vm_sa_user_password         = var.vm_sa_user_password
    vm_sa_user_ssh_keys         = var.vm_sa_user_ssh_keys
}