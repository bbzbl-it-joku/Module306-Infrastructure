module "prddb01" {
  source = "../modules/proxmox/almalinux9-basic"

  proxmox_server_url          = var.proxmox_server_url
  proxmox_web_username        = var.proxmox_web_username
  proxmox_ssh_username        = var.proxmox_ssh_username
  proxmox_user_password       = var.proxmox_user_password
  proxmox_api_token           = var.proxmox_api_token
  proxmox_server_ssl_insecure = var.proxmox_server_ssl_insecure

  vm_name        = "prddb01"
  vm_description = "Production PostgreSQL Database"
  vm_tags        = ["os-alma", "env-prod", "app-postgresql", "tier-db"]
  vm_id          = 3001

  vm_cpu_cores = 4
  vm_memory    = 8192

  vm_ip_address = "192.168.1.101/24"
  vm_ip_gateway = "192.168.1.1"

  vm_disks = [{
    datastore_id = "local-lvm"
    file_format  = "raw"
    interface    = "scsi0"
    size         = "16"
    ssd          = true
  }]

  vm_start         = true
  vm_start_on_boot = true
  vm_startup_order = 10

  vm_sa_user_password = var.vm_sa_user_password
  vm_sa_user_ssh_keys = var.vm_sa_user_ssh_keys
}

# Production MinIO Object Storage
module "prds301" {
  source = "../modules/proxmox/almalinux9-basic"

  proxmox_server_url          = var.proxmox_server_url
  proxmox_web_username        = var.proxmox_web_username
  proxmox_ssh_username        = var.proxmox_ssh_username
  proxmox_user_password       = var.proxmox_user_password
  proxmox_api_token           = var.proxmox_api_token
  proxmox_server_ssl_insecure = var.proxmox_server_ssl_insecure

  vm_name        = "prds301"
  vm_description = "Production MinIO Object Storage"
  vm_tags        = ["os-alma", "env-prod", "app-minio", "tier-storage"]
  vm_id          = 3002

  vm_cpu_cores = 4
  vm_memory    = 4096

  vm_ip_address = "192.168.1.102/24"
  vm_ip_gateway = "192.168.1.1"

  vm_disks = [{
    datastore_id = "local-lvm"
    file_format  = "raw"
    interface    = "scsi0"
    size         = "16"
    ssd          = true
  }]

  vm_start         = true
  vm_start_on_boot = true
  vm_startup_order = 11

  vm_sa_user_password = var.vm_sa_user_password
  vm_sa_user_ssh_keys = var.vm_sa_user_ssh_keys
}

# Production Keycloak Identity Management
module "prdkc01" {
  source = "../modules/proxmox/almalinux9-basic"

  proxmox_server_url          = var.proxmox_server_url
  proxmox_web_username        = var.proxmox_web_username
  proxmox_ssh_username        = var.proxmox_ssh_username
  proxmox_user_password       = var.proxmox_user_password
  proxmox_api_token           = var.proxmox_api_token
  proxmox_server_ssl_insecure = var.proxmox_server_ssl_insecure

  vm_name        = "prdkc01"
  vm_description = "Production Keycloak Identity Management"
  vm_tags        = ["os-alma", "env-prod", "app-keycloak", "tier-auth"]
  vm_id          = 3003

  vm_cpu_cores = 4
  vm_memory    = 8192

  vm_ip_address = "192.168.1.103/24"
  vm_ip_gateway = "192.168.1.1"

  vm_disks = [{
    datastore_id = "local-lvm"
    file_format  = "raw"
    interface    = "scsi0"
    size         = "16"
    ssd          = true
  }]

  vm_start         = true
  vm_start_on_boot = true
  vm_startup_order = 12

  vm_sa_user_password = var.vm_sa_user_password
  vm_sa_user_ssh_keys = var.vm_sa_user_ssh_keys
}

# Production Spring Boot Application
module "prdapp01" {
  source = "../modules/proxmox/almalinux9-basic"

  proxmox_server_url          = var.proxmox_server_url
  proxmox_web_username        = var.proxmox_web_username
  proxmox_ssh_username        = var.proxmox_ssh_username
  proxmox_user_password       = var.proxmox_user_password
  proxmox_api_token           = var.proxmox_api_token
  proxmox_server_ssl_insecure = var.proxmox_server_ssl_insecure

  vm_name        = "prdapp01"
  vm_description = "Production Spring Boot Application"
  vm_tags        = ["os-alma", "env-prod", "app-springboot", "tier-app"]
  vm_id          = 3004

  vm_cpu_cores = 4
  vm_memory    = 8192

  vm_ip_address = "192.168.1.104/24"
  vm_ip_gateway = "192.168.1.1"

  vm_disks = [{
    datastore_id = "local-lvm"
    file_format  = "raw"
    interface    = "scsi0"
    size         = "16"
    ssd          = true
  }]

  vm_start         = true
  vm_start_on_boot = true
  vm_startup_order = 13

  vm_sa_user_password = var.vm_sa_user_password
  vm_sa_user_ssh_keys = var.vm_sa_user_ssh_keys
}

# =============================================================================
# Production Environment - DMZ (Frontend Services)
# =============================================================================

# Production NGINX Webserver (DMZ)
module "prdweb01" {
  source = "../modules/proxmox/almalinux9-basic"

  proxmox_server_url          = var.proxmox_server_url
  proxmox_web_username        = var.proxmox_web_username
  proxmox_ssh_username        = var.proxmox_ssh_username
  proxmox_user_password       = var.proxmox_user_password
  proxmox_api_token           = var.proxmox_api_token
  proxmox_server_ssl_insecure = var.proxmox_server_ssl_insecure

  vm_name        = "prdweb01"
  vm_description = "Production NGINX Webserver (DMZ)"
  vm_tags        = ["os-alma", "env-prod", "app-nginx", "tier-web", "zone-dmz"]
  vm_id          = 4001

  vm_cpu_cores = 4
  vm_memory    = 4096

  vm_ip_address = "192.168.100.50/24"
  vm_ip_gateway = "192.168.100.1"

  vm_network_devices = [{
      bridge    = "vmbr1"
      enabled   = true
      firewall  = false
      model     = "virtio"
      vlan_id   = null
  }]

  vm_disks = [{
    datastore_id = "local-lvm"
    file_format  = "raw"
    interface    = "scsi0"
    size         = "16"
    ssd          = true
  }]

  vm_start         = true
  vm_start_on_boot = true
  vm_startup_order = 20

  vm_sa_user_password = var.vm_sa_user_password
  vm_sa_user_ssh_keys = var.vm_sa_user_ssh_keys
}

# Production Traefik Load Balancer (DMZ)
module "prdrpx01" {
  source = "../modules/proxmox/almalinux9-basic"

  proxmox_server_url          = var.proxmox_server_url
  proxmox_web_username        = var.proxmox_web_username
  proxmox_ssh_username        = var.proxmox_ssh_username
  proxmox_user_password       = var.proxmox_user_password
  proxmox_api_token           = var.proxmox_api_token
  proxmox_server_ssl_insecure = var.proxmox_server_ssl_insecure

  vm_name        = "prdrpx01"
  vm_description = "Production Traefik Load Balancer (DMZ)"
  vm_tags        = ["os-alma", "env-prod", "app-traefik", "tier-proxy", "zone-dmz"]
  vm_id          = 4002

  vm_cpu_cores = 4
  vm_memory    = 4096

  vm_ip_address = "192.168.100.51/24"
  vm_ip_gateway = "192.168.100.1"

  vm_network_devices = [{
      bridge    = "vmbr1"
      enabled   = true
      firewall  = false
      model     = "virtio"
      vlan_id   = null
  }]

  vm_disks = [{
    datastore_id = "local-lvm"
    file_format  = "raw"
    interface    = "scsi0"
    size         = "16"
    ssd          = true
  }]

  vm_start         = true
  vm_start_on_boot = true
  vm_startup_order = 21

  vm_sa_user_password = var.vm_sa_user_password
  vm_sa_user_ssh_keys = var.vm_sa_user_ssh_keys
}

# Production LAN DNS
module "prddb01_dns" {
  source = "../modules/opnsense/dns"

  opnsense_server_uri = var.opnsense_server_uri
  opnsense_api_key    = var.opnsense_api_key
  opnsense_api_secret = var.opnsense_api_secret

  dns_record_server   = "prddb01"
  dns_record_ip       = "192.168.1.101"
  dns_record_wildcard = false
}

module "prds301_dns" {
  source = "../modules/opnsense/dns"

  opnsense_server_uri = var.opnsense_server_uri
  opnsense_api_key    = var.opnsense_api_key
  opnsense_api_secret = var.opnsense_api_secret

  dns_record_server   = "prds301"
  dns_record_ip       = "192.168.1.102"
  dns_record_wildcard = false
}

module "prdkc01_dns" {
  source = "../modules/opnsense/dns"

  opnsense_server_uri = var.opnsense_server_uri
  opnsense_api_key    = var.opnsense_api_key
  opnsense_api_secret = var.opnsense_api_secret

  dns_record_server   = "prdkc01"
  dns_record_ip       = "192.168.1.103"
  dns_record_wildcard = false
}

module "prdapp01_dns" {
  source = "../modules/opnsense/dns"

  opnsense_server_uri = var.opnsense_server_uri
  opnsense_api_key    = var.opnsense_api_key
  opnsense_api_secret = var.opnsense_api_secret

  dns_record_server   = "prdapp01"
  dns_record_ip       = "192.168.1.104"
  dns_record_wildcard = false
}

# Production DMZ DNS
module "prdweb01_dns" {
  source = "../modules/opnsense/dns"

  opnsense_server_uri = var.opnsense_server_uri
  opnsense_api_key    = var.opnsense_api_key
  opnsense_api_secret = var.opnsense_api_secret

  dns_record_server   = "prdweb01"
  dns_record_ip       = "192.168.100.50"
  dns_record_wildcard = false
}

module "prdrpx01_dns" {
  source = "../modules/opnsense/dns"

  opnsense_server_uri = var.opnsense_server_uri
  opnsense_api_key    = var.opnsense_api_key
  opnsense_api_secret = var.opnsense_api_secret

  dns_record_server   = "prdrpx01"
  dns_record_ip       = "192.168.100.51"
  dns_record_wildcard = false
}