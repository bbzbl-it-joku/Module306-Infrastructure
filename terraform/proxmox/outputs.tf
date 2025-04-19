/*
* AlmaLinux 9 Proxmox Deployment - Outputs
* ======================================
*
* This file defines the outputs from the root module
* that provide information about the deployed VMs.
*/

//----------------------------------------------------------------------
// Dev Environment Outputs
//----------------------------------------------------------------------

output "dev_vm_ips" {
  description = "IP addresses of development VMs"
  value = {
    for name, vm in {
      devtf01 = try(module.devtf01.primary_ipv4_address, ""),
      devtf02 = try(module.devtf02.primary_ipv4_address, ""),
      devtf03 = try(module.devtf03.primary_ipv4_address, "")
    } : name => vm if vm != ""
  }
}

//----------------------------------------------------------------------
// Test Environment Outputs
//----------------------------------------------------------------------

output "test_vm_ips" {
  description = "IP addresses of test VMs"
  value = {
    for name, vm in {
      tsttf01 = try(module.tsttf01.primary_ipv4_address, ""),
      tsttf02 = try(module.tsttf02.primary_ipv4_address, ""),
      tsttf03 = try(module.tsttf03.primary_ipv4_address, "")
    } : name => vm if vm != ""
  }
}

//----------------------------------------------------------------------
// Production Environment Outputs
//----------------------------------------------------------------------

output "prod_vm_ips" {
  description = "IP addresses of production VMs"
  value = {
    for name, vm in {
      prdtf01 = try(module.prdtf01.primary_ipv4_address, ""),
      prdtf02 = try(module.prdtf02.primary_ipv4_address, ""),
      prdtf03 = try(module.prdtf03.primary_ipv4_address, "")
    } : name => vm if vm != ""
  }
}

//----------------------------------------------------------------------
// Combined Outputs
//----------------------------------------------------------------------

output "all_vms" {
  description = "Summary of all VMs created by this configuration"
  value = {
    development = {
      for name in try(keys(module.devtf01), []) : name => {
        id = try(module.devtf01.vm_id, ""),
        name = try(module.devtf01.vm_name, ""),
        ip = try(module.devtf01.primary_ipv4_address, ""),
        status = try(module.devtf01.vm_status, "")
      }
    },
    testing = {
      for name in try(keys(module.tsttf01), []) : name => {
        id = try(module.tsttf01.vm_id, ""),
        name = try(module.tsttf01.vm_name, ""),
        ip = try(module.tsttf01.primary_ipv4_address, ""),
        status = try(module.tsttf01.vm_status, "")
      }
    },
    production = {
      for name in try(keys(module.prdtf01), []) : name => {
        id = try(module.prdtf01.vm_id, ""),
        name = try(module.prdtf01.vm_name, ""),
        ip = try(module.prdtf01.primary_ipv4_address, ""),
        status = try(module.prdtf01.vm_status, "")
      }
    }
  }
}