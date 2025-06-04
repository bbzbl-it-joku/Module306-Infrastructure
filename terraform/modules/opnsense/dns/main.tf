/*
* OPNSense Basic Unbound DNS Module - Main Configuration
* =====================================================
*
* This module creates DNS entries in OPNSense Unbound DNS resolver.
* 
* Features:
* - Creates main DNS entry (hostname.domain)
* - Optionally creates wildcard entry (*.domain)
* - Uses OPNSense API for configuration
*
* Resources created:
* - opnsense_unbound_host_override (main entry)
* - opnsense_unbound_host_override (wildcard, conditional)
*/

//----------------------------------------------------------------------
// Provider Configuration
//----------------------------------------------------------------------


//----------------------------------------------------------------------
// DNS Entry Resources
//----------------------------------------------------------------------

# Main DNS entry (hostname.domain -> IP)
resource "opnsense_unbound_host_override" "main" {
  hostname    = var.dns_record_server
  domain      = var.dns_record_domain
  server      = var.dns_record_ip
  description = var.dns_record_description != "" ? var.dns_record_description : "DNS entry for ${var.dns_record_server}.${var.dns_record_domain}"
  enabled     = var.dns_record_enabled

  lifecycle {
    create_before_destroy = true
  }
}

# Wildcard DNS entry (*.domain -> IP) - conditional creation
resource "opnsense_unbound_host_override" "wildcard" {
  count = var.dns_record_wildcard ? 1 : 0
  
  hostname    = "*"
  domain      = var.dns_record_domain
  server      = var.dns_record_ip
  description = var.dns_record_description != "" ? "${var.dns_record_description} (wildcard)" : "Wildcard DNS entry for *.${var.dns_record_domain}"
  enabled     = var.dns_record_enabled

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [opnsense_unbound_host_override.main]
}