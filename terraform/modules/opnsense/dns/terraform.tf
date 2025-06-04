/*
* OPNSense Basic Unbound DNS Module - Terraform Configuration
* ===================================================
*
* This file contains the Terraform configuration for the module,
* including required providers and versions.
*/

terraform {
  required_providers {
    opnsense = {
      source = "browningluke/opnsense"
      version = "0.11.0"
    }
  }
}
