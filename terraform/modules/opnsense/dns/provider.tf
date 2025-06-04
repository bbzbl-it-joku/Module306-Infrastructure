/*
* OPNSense Basic Unbound DNS Module - Provider Configuration
* ==================================================
*
* This file contains the OPNSense provider configuration.
* It supports api-key-based authentication.
*/

provider "opnsense" {
  uri        = var.opnsense_server_uri
  api_key    = var.opnsense_api_key
  api_secret = var.opnsense_api_secret
}