/*
* Test Environment AlmaLinux 9 VM Deployments
* =========================================
*
* This file defines test environment VMs based on AlmaLinux 9.
* Each VM is deployed using the almalinux9-basic module.
*
* Naming convention: 
* - tsttfXX: Test Terraform VMs (XX is a sequential number)
*/

#----------------------------------------------------------------------
# Test VM 01 - Basic test environment
#----------------------------------------------------------------------
module "tsttf01" {
    source = "../../modules/proxmox/almalinux9-basic"

    # Proxmox connection parameters (inherited from root module)
    proxmox_server_url          = var.proxmox_server_url
    proxmox_web_username        = var.proxmox_web_username
    proxmox_ssh_username        = var.proxmox_ssh_username
    proxmox_user_password       = var.proxmox_user_password
    proxmox_api_token           = var.proxmox_api_token
    proxmox_server_ssl_insecure = var.proxmox_server_ssl_insecure

    # Basic VM configuration
    vm_name                     = "tsttf01"
    vm_description              = "Test VM 01 - Basic AlmaLinux 9 configuration"
    vm_tags                     = concat(["test", "development"], local.common_tags)
    vm_id                       = 1001
    
    # Template configuration
    vm_ci_interface             = "scsi1"
    vm_template_id              = 9001
    
    # Network configuration
    vm_ip_address               = "dhcp"
    
    # Use default disk configuration from the module
    # vm_disks                  = local.standard_disk
    
    # Power management
    vm_start                    = true
    vm_start_on_boot            = false
    
    # Authentication and user configuration
    vm_sa_user_password         = var.vm_sa_user_password
    vm_sa_user_ssh_keys         = var.vm_sa_user_ssh_keys
}

#----------------------------------------------------------------------
# Test VM 02 - Database test environment
#----------------------------------------------------------------------
module "tsttf02" {
    source = "../../modules/proxmox/almalinux9-basic"

    # Proxmox connection parameters (inherited from root module)
    proxmox_server_url          = var.proxmox_server_url
    proxmox_web_username        = var.proxmox_web_username
    proxmox_ssh_username        = var.proxmox_ssh_username
    proxmox_user_password       = var.proxmox_user_password
    proxmox_api_token           = var.proxmox_api_token
    proxmox_server_ssl_insecure = var.proxmox_server_ssl_insecure

    # Basic VM configuration
    vm_name                     = "tsttf02"
    vm_description              = "Test VM 02 - Database test environment"
    vm_tags                     = concat(["test", "database"], local.common_tags)
    vm_id                       = 1002
    
    # Template configuration
    vm_ci_interface             = "scsi1"
    vm_template_id              = 9001
    
    # Network configuration
    vm_ip_address               = "dhcp"
    
    # Enhanced disk configuration for database
    vm_disks                    = [
      { 
        datastore_id  = "local-lvm" 
        file_format   = "raw" 
        interface     = "scsi0" 
        size          = "32" 
        ssd           = false 
      },
      { 
        datastore_id  = "local-lvm" 
        file_format   = "raw" 
        interface     = "scsi2" 
        size          = "100" 
        ssd           = true 
      }
    ]
    
    # Power management
    vm_start                    = false
    vm_start_on_boot            = false
    
    # Authentication and user configuration
    vm_sa_user_password         = var.vm_sa_user_password
    vm_sa_user_ssh_keys         = var.vm_sa_user_ssh_keys
}

#----------------------------------------------------------------------
# Test VM 03 - Web application test environment
#----------------------------------------------------------------------
module "tsttf03" {
    source = "../../modules/proxmox/almalinux9-basic"

    # Proxmox connection parameters (inherited from root module)
    proxmox_server_url          = var.proxmox_server_url
    proxmox_web_username        = var.proxmox_web_username
    proxmox_ssh_username        = var.proxmox_ssh_username
    proxmox_user_password       = var.proxmox_user_password
    proxmox_api_token           = var.proxmox_api_token
    proxmox_server_ssl_insecure = var.proxmox_server_ssl_insecure

    # Basic VM configuration
    vm_name                     = "tsttf03"
    vm_description              = "Test VM 03 - Web application test environment"
    vm_tags                     = concat(["test", "webserver"], local.common_tags)
    vm_id                       = 1003
    
    # Template configuration
    vm_ci_interface             = "scsi1"
    vm_template_id              = 9001
    
    # Network configuration
    vm_ip_address               = "dhcp"
    
    # Standard disk configuration
    vm_disks                    = local.standard_disk
    
    # Power management
    vm_start                    = false
    vm_start_on_boot            = false
    
    # Authentication and user configuration
    vm_sa_user_password         = var.vm_sa_user_password
    vm_sa_user_ssh_keys         = var.vm_sa_user_ssh_keys
}