/*
* AlmaLinux 9 Basic VM Module - Variables
* ======================================
*
* This file contains all variable declarations for the AlmaLinux 9 VM module.
*
* Variable organization:
* 1. Proxmox Connection Variables
* 2. VM Basic Configuration Variables
* 3. VM Hardware Configuration Variables
* 4. VM Network Configuration Variables
* 5. VM Storage Configuration Variables
* 6. VM Template Configuration Variables
* 7. VM User Configuration Variables
* 8. Local Variables
*/

//----------------------------------------------------------------------
// 1. Proxmox Connection Variables
//----------------------------------------------------------------------

variable "proxmox_server_url" {
    description = "The URL of the Proxmox server that Terraform connects to (e.g., https://proxmox.example.com:8006)"
    type = string
    default = "https://192.168.0.100:8006"
}

variable "proxmox_web_username" {
    description = "The username for Proxmox authentication when using credentials (e.g., root@pam)"
    type = string
    default = "root@pam"
}

variable "proxmox_ssh_username" {
    description = "The SSH username for Proxmox when using API token authentication"
    type = string
    default = "root"
}

variable "proxmox_user_password" {
    description = "The password for Proxmox authentication when using credentials"
    type = string
    sensitive = true
}

variable "proxmox_api_token" {
    description = "The API token for Proxmox authentication when using token-based auth"
    type = string
    sensitive = true
}

variable "proxmox_server_ssl_insecure" {
    description = "Whether to skip SSL certificate validation for Proxmox connection (false recommended for production)"
    type = bool
    default = true
}

//----------------------------------------------------------------------
// 2. VM Basic Configuration Variables
//----------------------------------------------------------------------

variable "vm_name" {
  description = "The name of the VM to be created (must be unique in the cluster)"
  type = string
}

variable "vm_description" {
  description = "The description for the VM that appears in Proxmox UI"
  type = string
  default = " Managed by Terraform "
}

variable "vm_tags" {
  description = "List of tags to assign to the VM for organization and filtering"
  type = list(string)
  default = ["terraform", "almalinux9", "ansible_semaphore"]
}

variable "vm_id" {
  description = "The unique numeric ID for the VM in Proxmox (must be unique in the cluster)"
  type = number
}

variable "vm_node_name" {
  description = "The name of the Proxmox node where the VM should be created"
  type = string
  default = "prdpve01"
}

variable "vm_start" {
  description = "Whether to start the VM immediately after creation"
  type = bool
  default = true
}

variable "vm_start_on_boot" {
  description = "Whether the VM should start automatically when the Proxmox node boots"
  type = bool
  default = false
}

variable "vm_startup_order" {
  description = "The boot order priority for this VM when the node starts (higher numbers boot later)"
  type = number
  default = 0
}

variable "vm_up_down_delay" {
  description = "The delay in seconds between VM power operations when starting/stopping multiple VMs"
  type = number
  default = 30
}

//----------------------------------------------------------------------
// 3. VM Storage Configuration Variables 
//----------------------------------------------------------------------

variable "vm_datastore_id" {
  description = "The Proxmox storage ID where the VM disks will be stored"
  type = string
  default = "local-lvm"
}

variable "vm_disks" {
  description = "The configuration for VM disk devices (list of objects)"
  type = list(object({
    datastore_id = string
    file_format = string
    interface = string
    size = string
    ssd = bool
  }))
  default = [
    { 
      datastore_id = "local-lvm" 
      file_format = "raw" 
      interface = "scsi0" 
      size = "32" 
      ssd = false 
    }
  ]
}

//----------------------------------------------------------------------
// 4. VM Network Configuration Variables
//----------------------------------------------------------------------

variable "vm_network_devices" {
  description = "The configuration for VM network devices (list of objects)"
  type = list(object({
    bridge = string
    enabled = bool
    firewall = bool
    model = string
    vlan_id = number
  }))
  default = [
    {
      bridge = "vmbr0"
      enabled = true
      firewall = false
      model = "virtio"
      vlan_id = null
    }
  ]
}

variable "vm_ip_address" {
  description = "The IP address for the VM (use 'dhcp' for automatic IP assignment)"
  type = string
  default = "dhcp"
}

variable "vm_ip_gateway" {
  description = "The default gateway IP address for the VM (ignored when vm_ip_address is 'dhcp')"
  type = string
  default = ""
}

//----------------------------------------------------------------------
// 5. VM Template Configuration Variables
//----------------------------------------------------------------------

variable "vm_template_node_name" {
  description = "The name of the Proxmox node where the source template is located"
  type = string
  default = "prdpve01"
}

variable "vm_template_id" {
  description = "The VM ID of the template to clone for creating this VM"
  type = number
  default = 9000
}

variable "vm_ci_interface" {
  description = "The disk interface used for the Cloud-Init drive (e.g., ide2, scsi1)"
  type = string
  default = "scsi1"
}

//----------------------------------------------------------------------
// 6. VM User Configuration Variables
//----------------------------------------------------------------------

variable "vm_sa_user_name" {
  description = "The username for the service account to be created in the VM"
  type = string
  default = "sa_ansible"
}

variable "vm_sa_user_password" {
  description = "The password for the service account (should be provided securely)"
  type = string
  sensitive = true
}

variable "vm_sa_user_ssh_keys" {
  description = "List of SSH public keys to authorize for the service account"
  type = list(string)
  sensitive = true
}

//----------------------------------------------------------------------
// 7. Local Variables
//----------------------------------------------------------------------

locals {
  # Ensure critical tags are always included
  vm_all_tags = concat(var.vm_tags, ["terraform", "almalinux9", "ansible_semaphore"])
  
  # Ensure description includes management information
  vm_full_description = replace(var.vm_description, "^(?!.*Managed by Terraform & Ansible Semaphore).*", "${var.vm_description} Managed by Terraform & Ansible Semaphore")
}