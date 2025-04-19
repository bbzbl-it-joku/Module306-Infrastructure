/*
* Production Environment AlmaLinux 9 VM Deployments
* ==============================================
*
* This file defines production environment VMs based on AlmaLinux 9.
* Each VM is deployed using the almalinux9-basic module.
*
* Naming convention: 
* - prdtfXX: Production Terraform VMs (XX is a sequential number)
*/

#----------------------------------------------------------------------
# Production VM 01 - Web Server
#----------------------------------------------------------------------
module "prdtf01" {
    source = "../../modules/proxmox/almalinux9-basic"

    # Proxmox connection parameters (inherited from root module)
    proxmox_server_url          = var.proxmox_server_url
    proxmox_web_username        = var.proxmox_web_username
    proxmox_ssh_username        = var.proxmox_ssh_username
    proxmox_user_password       = var.proxmox_user_password
    proxmox_api_token           = var.proxmox_api_token
    proxmox_server_ssl_insecure = var.proxmox_server_ssl_insecure

    # Basic VM configuration
    vm_name                     = "prdtf01"
    vm_description              = "Production Web Server"
    vm_tags                     = concat(["prod", "webserver"], local.common_tags)
    vm_id                       = 3001
    
    # Template configuration
    vm_ci_interface             = "scsi1"
    vm_template_id              = 9001
    
    # Hardware configuration - production needs more resources
    vm_cores                    = 4
    vm_memory                   = 8192
    
    # Network configuration - use static IP for production
    vm_ip_address               = "192.168.10.101/24"
    vm_ip_gateway               = "192.168.10.1"
    
    # Standard disk configuration
    vm_disks                    = [
      { 
        datastore_id  = "local-lvm" 
        file_format   = "raw" 
        interface     = "scsi0" 
        size          = "50" 
        ssd           = true
      }
    ]
    
    # Power management - always on for production availability
    vm_start                    = true
    vm_start_on_boot            = true
    vm_startup_order            = 100
    
    # Authentication and user configuration
    vm_sa_user_password         = var.vm_sa_user_password
    vm_sa_user_ssh_keys         = var.vm_sa_user_ssh_keys
}

#----------------------------------------------------------------------
# Production VM 02 - Database Server
#----------------------------------------------------------------------
module "prdtf02" {
    source = "../../modules/proxmox/almalinux9-basic"

    # Proxmox connection parameters (inherited from root module)
    proxmox_server_url          = var.proxmox_server_url
    proxmox_web_username        = var.proxmox_web_username
    proxmox_ssh_username        = var.proxmox_ssh_username
    proxmox_user_password       = var.proxmox_user_password
    proxmox_api_token           = var.proxmox_api_token
    proxmox_server_ssl_insecure = var.proxmox_server_ssl_insecure

    # Basic VM configuration
    vm_name                     = "prdtf02"
    vm_description              = "Production Database Server"
    vm_tags                     = concat(["prod", "database"], local.common_tags)
    vm_id                       = 3002
    
    # Template configuration
    vm_ci_interface             = "scsi1"
    vm_template_id              = 9001
    
    # Hardware configuration - database needs more memory
    vm_cores                    = 8
    vm_memory                   = 16384
    
    # Network configuration - use static IP for production
    vm_ip_address               = "192.168.10.102/24"
    vm_ip_gateway               = "192.168.10.1"
    
    # Enhanced disk configuration for database
    vm_disks                    = [
      { 
        datastore_id  = "local-lvm" 
        file_format   = "raw" 
        interface     = "scsi0" 
        size          = "50" 
        ssd           = true
      },
      { 
        datastore_id  = "local-lvm" 
        file_format   = "raw" 
        interface     = "scsi2" 
        size          = "500" 
        ssd           = true
      }
    ]
    
    # Power management - always on for production availability
    vm_start                    = true
    vm_start_on_boot            = true
    vm_startup_order            = 50  # Start before web server
    
    # Authentication and user configuration
    vm_sa_user_password         = var.vm_sa_user_password
    vm_sa_user_ssh_keys         = var.vm_sa_user_ssh_keys
}

#----------------------------------------------------------------------
# Production VM 03 - Application Server
#----------------------------------------------------------------------
module "prdtf03" {
    source = "../../modules/proxmox/almalinux9-basic"

    # Proxmox connection parameters (inherited from root module)
    proxmox_server_url          = var.proxmox_server_url
    proxmox_web_username        = var.proxmox_web_username
    proxmox_ssh_username        = var.proxmox_ssh_username
    proxmox_user_password       = var.proxmox_user_password
    proxmox_api_token           = var.proxmox_api_token
    proxmox_server_ssl_insecure = var.proxmox_server_ssl_insecure

    # Basic VM configuration
    vm_name                     = "prdtf03"
    vm_description              = "Production Application Server"
    vm_tags                     = concat(["prod", "appserver"], local.common_tags)
    vm_id                       = 3003
    
    # Template configuration
    vm_ci_interface             = "scsi1"
    vm_template_id              = 9001
    
    # Hardware configuration
    vm_cores                    = 8
    vm_memory                   = 16384
    
    # Network configuration - use static IP for production
    vm_ip_address               = "192.168.10.103/24"
    vm_ip_gateway               = "192.168.10.1"
    
    # Enhanced disk configuration for application server
    vm_disks                    = [
      { 
        datastore_id  = "local-lvm" 
        file_format   = "raw" 
        interface     = "scsi0" 
        size          = "100" 
        ssd           = true
      }
    ]
    
    # Power management - always on for production availability
    vm_start                    = true
    vm_start_on_boot            = true
    vm_startup_order            = 80  # Start after database but before web
    
    # Authentication and user configuration
    vm_sa_user_password         = var.vm_sa_user_password
    vm_sa_user_ssh_keys         = var.vm_sa_user_ssh_keys
}