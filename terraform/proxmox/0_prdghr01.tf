#----------------------------------------------------------------------
# PROD VM 01 - Github Runner Server
#----------------------------------------------------------------------
module "prdghr01" {
    source = "../modules/proxmox/almalinux9-basic"

    # Proxmox connection parameters (inherited from root module)
    proxmox_server_url          = var.proxmox_server_url
    proxmox_web_username        = var.proxmox_web_username
    proxmox_ssh_username        = var.proxmox_ssh_username
    proxmox_user_password       = var.proxmox_user_password
    proxmox_api_token           = var.proxmox_api_token
    proxmox_server_ssl_insecure = var.proxmox_server_ssl_insecure

    # Basic VM configuration
    vm_name                     = "prdghr01"
    vm_description              = "Github Runner Server"
    vm_tags                     = ["prd", "Github Runner"]
    vm_id                       = 1001

    vm_cpu_cores = 4
    vm_memory = 4096
    
    # Template configuration
    vm_ci_interface             = "scsi1"
    vm_template_id              = 9000
    
    # Network configuration
    vm_ip_address               = "192.168.1.15/24"
    vm_ip_gateway               = "192.168.1.1" 
    
    # Enhanced disk configuration for development
    vm_disks = [
      { 
        datastore_id  = "local-lvm" 
        file_format   = "raw" 
        interface     = "scsi0" 
        size          = "30" 
        ssd           = true
      }
    ]
    
    # Power management
    vm_start                    = true
    vm_start_on_boot            = true
    vm_startup_order            = 2
    
    # Authentication and user configuration
    vm_sa_user_password         = var.vm_sa_user_password
    vm_sa_user_ssh_keys         = var.vm_sa_user_ssh_keys
}

module "prdghr01_dns" {
  source = "../modules/opnsense/dns"

  opnsense_server_uri = var.opnsense_server_uri
  opnsense_api_key = var.opnsense_api_key
  opnsense_api_secret = var.opnsense_api_secret

  dns_record_server = "prdghr01"
  dns_record_ip = "192.168.1.15"
  dns_record_wildcard = false

}