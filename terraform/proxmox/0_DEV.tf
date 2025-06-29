module "devweb01" {
  source = "../modules/proxmox/almalinux9-basic"

  proxmox_server_url          = var.proxmox_server_url
  proxmox_web_username        = var.proxmox_web_username
  proxmox_ssh_username        = var.proxmox_ssh_username
  proxmox_user_password       = var.proxmox_user_password
  proxmox_api_token           = var.proxmox_api_token
  proxmox_server_ssl_insecure = var.proxmox_server_ssl_insecure

  vm_name        = "devweb01"
  vm_description = "Development NGINX Webserver"
  vm_tags        = ["os-alma", "env-dev", "app-nginx", "tier-web"]
  vm_id          = 2001

  vm_cpu_cores = 2
  vm_memory    = 2048

  vm_ip_address = "192.168.1.50/24"
  vm_ip_gateway = "192.168.1.1"

  vm_disks = [{
    datastore_id = "local-lvm"
    file_format  = "raw"
    interface    = "scsi0"
    size         = "16"
    ssd          = true
  }]

  vm_start         = true
  vm_start_on_boot = false
  vm_startup_order = 10

  vm_sa_user_password = var.vm_sa_user_password
  vm_sa_user_ssh_keys = var.vm_sa_user_ssh_keys
}

# Development PostgreSQL Database
module "devdb01" {
  source = "../modules/proxmox/almalinux9-basic"

  proxmox_server_url          = var.proxmox_server_url
  proxmox_web_username        = var.proxmox_web_username
  proxmox_ssh_username        = var.proxmox_ssh_username
  proxmox_user_password       = var.proxmox_user_password
  proxmox_api_token           = var.proxmox_api_token
  proxmox_server_ssl_insecure = var.proxmox_server_ssl_insecure

  vm_name        = "devdb01"
  vm_description = "Development PostgreSQL Database"
  vm_tags        = ["os-alma", "env-dev", "app-postgresql", "tier-db"]
  vm_id          = 2002

  vm_cpu_cores = 2
  vm_memory    = 4096

  vm_ip_address = "192.168.1.51/24"
  vm_ip_gateway = "192.168.1.1"

  vm_disks = [{
    datastore_id = "local-lvm"
    file_format  = "raw"
    interface    = "scsi0"
    size         = "16"
    ssd          = true
  }]

  vm_start         = true
  vm_start_on_boot = false
  vm_startup_order = 5

  vm_sa_user_password = var.vm_sa_user_password
  vm_sa_user_ssh_keys = var.vm_sa_user_ssh_keys
}

# Development MinIO Object Storage
module "devs301" {
  source = "../modules/proxmox/almalinux9-basic"

  proxmox_server_url          = var.proxmox_server_url
  proxmox_web_username        = var.proxmox_web_username
  proxmox_ssh_username        = var.proxmox_ssh_username
  proxmox_user_password       = var.proxmox_user_password
  proxmox_api_token           = var.proxmox_api_token
  proxmox_server_ssl_insecure = var.proxmox_server_ssl_insecure

  vm_name        = "devs301"
  vm_description = "Development MinIO Object Storage"
  vm_tags        = ["os-alma", "env-dev", "app-minio", "tier-storage"]
  vm_id          = 2003

  vm_cpu_cores = 2
  vm_memory    = 2048

  vm_ip_address = "192.168.1.52/24"
  vm_ip_gateway = "192.168.1.1"

  vm_disks = [{
    datastore_id = "local-lvm"
    file_format  = "raw"
    interface    = "scsi0"
    size         = "16"
    ssd          = true
  }]

  vm_start         = true
  vm_start_on_boot = false
  vm_startup_order = 6

  vm_sa_user_password = var.vm_sa_user_password
  vm_sa_user_ssh_keys = var.vm_sa_user_ssh_keys
}

# Development Traefik Load Balancer
module "devrpx01" {
  source = "../modules/proxmox/almalinux9-basic"

  proxmox_server_url          = var.proxmox_server_url
  proxmox_web_username        = var.proxmox_web_username
  proxmox_ssh_username        = var.proxmox_ssh_username
  proxmox_user_password       = var.proxmox_user_password
  proxmox_api_token           = var.proxmox_api_token
  proxmox_server_ssl_insecure = var.proxmox_server_ssl_insecure

  vm_name        = "devrpx01"
  vm_description = "Development Traefik Load Balancer"
  vm_tags        = ["os-alma", "env-dev", "app-traefik", "tier-proxy"]
  vm_id          = 2004

  vm_cpu_cores = 2
  vm_memory    = 2048

  vm_ip_address = "192.168.1.53/24"
  vm_ip_gateway = "192.168.1.1"

  vm_disks = [{
    datastore_id = "local-lvm"
    file_format  = "raw"
    interface    = "scsi0"
    size         = "16"
    ssd          = true
  }]

  vm_start         = true
  vm_start_on_boot = false
  vm_startup_order = 7

  vm_sa_user_password = var.vm_sa_user_password
  vm_sa_user_ssh_keys = var.vm_sa_user_ssh_keys
}

# Development Keycloak Identity Management
module "devkc01" {
  source = "../modules/proxmox/almalinux9-basic"

  proxmox_server_url          = var.proxmox_server_url
  proxmox_web_username        = var.proxmox_web_username
  proxmox_ssh_username        = var.proxmox_ssh_username
  proxmox_user_password       = var.proxmox_user_password
  proxmox_api_token           = var.proxmox_api_token
  proxmox_server_ssl_insecure = var.proxmox_server_ssl_insecure

  vm_name        = "devkc01"
  vm_description = "Development Keycloak Identity Management"
  vm_tags        = ["os-alma", "env-dev", "app-keycloak", "tier-auth"]
  vm_id          = 2005

  vm_cpu_cores = 2
  vm_memory    = 4096

  vm_ip_address = "192.168.1.54/24"
  vm_ip_gateway = "192.168.1.1"

  vm_disks = [{
    datastore_id = "local-lvm"
    file_format  = "raw"
    interface    = "scsi0"
    size         = "16"
    ssd          = true
  }]

  vm_start         = true
  vm_start_on_boot = false
  vm_startup_order = 8

  vm_sa_user_password = var.vm_sa_user_password
  vm_sa_user_ssh_keys = var.vm_sa_user_ssh_keys
}

# Development Spring Boot Application
module "devapp01" {
  source = "../modules/proxmox/almalinux9-basic"

  proxmox_server_url          = var.proxmox_server_url
  proxmox_web_username        = var.proxmox_web_username
  proxmox_ssh_username        = var.proxmox_ssh_username
  proxmox_user_password       = var.proxmox_user_password
  proxmox_api_token           = var.proxmox_api_token
  proxmox_server_ssl_insecure = var.proxmox_server_ssl_insecure

  vm_name        = "devapp01"
  vm_description = "Development Spring Boot Application"
  vm_tags        = ["os-alma", "env-dev", "app-springboot", "tier-app"]
  vm_id          = 2006

  vm_cpu_cores = 2
  vm_memory    = 4096

  vm_ip_address = "192.168.1.55/24"
  vm_ip_gateway = "192.168.1.1"

  vm_disks = [{
    datastore_id = "local-lvm"
    file_format  = "raw"
    interface    = "scsi0"
    size         = "16"
    ssd          = true
  }]

  vm_start         = true
  vm_start_on_boot = false
  vm_startup_order = 9

  vm_sa_user_password = var.vm_sa_user_password
  vm_sa_user_ssh_keys = var.vm_sa_user_ssh_keys
}


# Development Environment DNS
module "devweb01_dns" {
  source = "../modules/opnsense/dns"

  opnsense_server_uri = var.opnsense_server_uri
  opnsense_api_key    = var.opnsense_api_key
  opnsense_api_secret = var.opnsense_api_secret

  dns_record_server   = "devweb01"
  dns_record_ip       = "192.168.1.50"
  dns_record_wildcard = false
}

module "devdb01_dns" {
  source = "../modules/opnsense/dns"

  opnsense_server_uri = var.opnsense_server_uri
  opnsense_api_key    = var.opnsense_api_key
  opnsense_api_secret = var.opnsense_api_secret

  dns_record_server   = "devdb01"
  dns_record_ip       = "192.168.1.51"
  dns_record_wildcard = false
}

module "devs301_dns" {
  source = "../modules/opnsense/dns"

  opnsense_server_uri = var.opnsense_server_uri
  opnsense_api_key    = var.opnsense_api_key
  opnsense_api_secret = var.opnsense_api_secret

  dns_record_server   = "devs301"
  dns_record_ip       = "192.168.1.52"
  dns_record_wildcard = false
}

module "devrpx01_dns" {
  source = "../modules/opnsense/dns"

  opnsense_server_uri = var.opnsense_server_uri
  opnsense_api_key    = var.opnsense_api_key
  opnsense_api_secret = var.opnsense_api_secret

  dns_record_server   = "devrpx01"
  dns_record_ip       = "192.168.1.53"
  dns_record_wildcard = false
}

module "devkc01_dns" {
  source = "../modules/opnsense/dns"

  opnsense_server_uri = var.opnsense_server_uri
  opnsense_api_key    = var.opnsense_api_key
  opnsense_api_secret = var.opnsense_api_secret

  dns_record_server   = "devkc01"
  dns_record_ip       = "192.168.1.54"
  dns_record_wildcard = false
}

module "devapp01_dns" {
  source = "../modules/opnsense/dns"

  opnsense_server_uri = var.opnsense_server_uri
  opnsense_api_key    = var.opnsense_api_key
  opnsense_api_secret = var.opnsense_api_secret

  dns_record_server   = "devapp01"
  dns_record_ip       = "192.168.1.55"
  dns_record_wildcard = false
}