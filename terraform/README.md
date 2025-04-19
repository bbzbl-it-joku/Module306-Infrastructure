# AlmaLinux 9 Proxmox Deployment - Terraform Configuration

This directory contains Terraform configurations for deploying AlmaLinux 9 virtual machines on Proxmox VE using templates created with the provided Packer configuration.

## Directory Structure

```
terraform/
├── proxmox/                  # Main Terraform deployment directory
│   ├── main.tf               # Main Terraform configuration
│   ├── outputs.tf            # Output declarations
│   ├── provider.tf           # Provider configuration
│   ├── terraform.tf          # Terraform version and backends
│   ├── vars.tf               # Main variable declarations
│   ├── terraform.tfvars.example  # Example variable values (template)
│   └── deployments/          # VM deployment configurations
│       ├── dev.tf            # Development VMs
│       ├── test.tf           # Test VMs
│       └── prod.tf           # Production VMs
└── modules/                  # Reusable Terraform modules
    └── proxmox/              # Proxmox-specific modules
        └── almalinux9-basic/ # AlmaLinux 9 basic VM module
            ├── main.tf       # Main module configuration
            ├── outputs.tf    # Module outputs
            ├── provider.tf   # Provider requirements
            ├── terraform.tf  # Terraform requirements
            └── vars.tf       # Module variables
```

## Configuration

1. Copy `terraform.tfvars.example` to `terraform.tfvars` and customize the variables:

```bash
cd proxmox
cp terraform.tfvars.example terraform.tfvars
```

2. Edit the `terraform.tfvars` file with your specific configurations:
   - Proxmox connection details
   - Authentication information
   - VM configuration preferences

3. For sensitive information, use environment variables instead of including them in the tfvars file:

```bash
export TF_VAR_proxmox_api_token="your-api-token"
export TF_VAR_proxmox_user_password="your-password"
export TF_VAR_vm_sa_user_password="your-service-account-password"
```

## Module Usage

### Basic Module Usage

The `almalinux9-basic` module creates AlmaLinux 9 VMs with the following features:
- Cloud-Init integration
- Service account setup
- Flexible disk and network configuration
- Startup/shutdown management

Example usage:

```hcl
module "example_vm" {
  source = "../modules/proxmox/almalinux9-basic"
  
  # Proxmox connection
  proxmox_server_url = "https://proxmox.example.com:8006"
  proxmox_api_token = var.proxmox_api_token
  
  # VM configuration
  vm_name = "example-vm"
  vm_id = 1001
  vm_template_id = 9000
  vm_ip_address = "dhcp"
  
  # Service account
  vm_sa_user_password = var.vm_sa_user_password
  vm_sa_user_ssh_keys = var.vm_sa_user_ssh_keys
}
```

### Available Configurations

The module supports extensive customization:

- **Hardware**: CPU cores, memory
- **Storage**: Multiple disks with different sizes and formats
- **Networking**: Multiple network interfaces, VLAN support
- **Cloud-Init**: Custom user accounts, SSH key injection
- **Startup**: Boot order, delays, auto-start options

## Deployment Environments

Deployments are organized by environment:

1. **Development** (`deployments/dev.tf`): VMs for development work
2. **Testing** (`deployments/test.tf`): VMs for quality assurance and testing
3. **Production** (`deployments/prod.tf`): VMs for production workloads

To deploy specific environments only:

```bash
# Deploy only development VMs
terraform apply -target=module.devtf01 -target=module.devtf02 -target=module.devtf03

# Deploy only test VMs
terraform apply -target=module.tsttf01 -target=module.tsttf02 -target=module.tsttf03

# Deploy only production VMs
terraform apply -target=module.prdtf01 -target=module.prdtf02 -target=module.prdtf03
```

## Prerequisites

- Terraform 1.0 or newer
- Proxmox VE 7.0 or newer
- AlmaLinux 9 template created using the provided Packer configuration
- Proxmox API token with appropriate permissions
- Network connectivity between your workstation and Proxmox

## Getting Started

1. Initialize Terraform:

```bash
cd proxmox
terraform init
```

2. Verify the plan:

```bash
terraform plan
```

3. Apply the configuration:

```bash
terraform apply
```

4. When you're finished, you can destroy the infrastructure:

```bash
terraform destroy
```
