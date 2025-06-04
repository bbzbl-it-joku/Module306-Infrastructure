/*
* OPNSense Basic Unbound DNS Module - Variables
* ======================================
*
* This file contains all variable declarations for the OPNSense Unbound DNS module.
*
* Variable organization:
* 1. OPNSense Connection Variables
* 2. DNS Entry Options
*/

//----------------------------------------------------------------------
// 1. OPNSense Connection Variables
//----------------------------------------------------------------------

variable "opnsense_server_uri" {
  description = "The URL of the OPNSense server that Terraform connects to"
  type        = string
  default     = "https://192.168.1.1"
}

variable "opnsense_api_key" {
  description = "The API key for OPNSense authentication"
  type        = string
  sensitive   = true
}

variable "opnsense_api_secret" {
  description = "The API secret for OPNSense authentication"
  type        = string
  sensitive   = true
}

//----------------------------------------------------------------------
// 2. DNS Entry Options
//----------------------------------------------------------------------

variable "dns_record_domain" {
  description = "The domain for the DNS entry"
  type        = string
  default     = "jokulab.ch"
}

variable "dns_record_server" {
  description = "The hostname/server name for the DNS entry"
  type        = string
}

variable "dns_record_ip" {
  description = "The IP address that the DNS entry should resolve to"
  type        = string
}

variable "dns_record_wildcard" {
  description = "Whether to create a wildcard DNS entry (*.domain) in addition to the main entry"
  type        = bool
  default     = false
}

variable "dns_record_description" {
  description = "Description for the DNS entries"
  type        = string
  default     = ""
}

variable "dns_record_enabled" {
  description = "Whether the DNS entries should be enabled"
  type        = bool
  default     = true
}
