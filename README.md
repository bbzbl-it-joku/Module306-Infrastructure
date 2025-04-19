# AlmaLinux 9 Proxmox Infrastructure Automation

A comprehensive solution for creating and managing AlmaLinux 9 virtual machines on Proxmox VE using HashiCorp Packer and Terraform.

## Overview

This project provides an end-to-end infrastructure as code solution for AlmaLinux 9 on Proxmox VE, with two main components:

1. **Template Creation**: Packer configuration to build AlmaLinux 9 templates on Proxmox VE using GitHub-hosted kickstart files
2. **VM Deployment**: Terraform modules and configurations to deploy VMs from the templates with various configurations for different environments

### Key Features

- **Cross-Network Template Creation**: Uses GitHub-hosted kickstart files instead of relying on Packer's HTTP server
- **UEFI Support**: Configured for modern UEFI boot with secure keys
- **Cloud-Init Integration**: Pre-configured for seamless VM provisioning
- **Environment Separation**: Organized deployment for development, testing, and production
- **Well-Documented**: Thoroughly commented code and comprehensive documentation
- **Modular Design**: Reusable components for maintainability and consistency

## Project Structure

```
Module306-Infrastructure/
├── README.md                             # Main project documentation
├── packer/                               # Packer configuration for template creation
│   ├── almalinux9.pkr.hcl                # Main Packer configuration file
│   ├── variables.pkr.hcl                 # Variable declarations for Packer
│   ├── config/                           # Configuration files
│   │   └── variables.auto.pkrvars.hcl    # Variable values for Packer (non-sensitive)
│   ├── scripts/                          # Shell scripts for provisioning
│   │   ├── cleanup.sh                    # VM cleanup script
│   │   └── setup-cloud-init.sh           # Cloud-init configuration
│   └── files/                            # Files to be copied to the VM
│       └── kickstart/                    # Kickstart configuration directory
│           └── ks.cfg                    # Kickstart configuration file
└── terraform/                            # Terraform configurations
    ├── README.md                         # Terraform-specific documentation
    ├── proxmox/                          # Main Terraform deployment directory
    │   ├── main.tf                       # Main Terraform configuration
    │   ├── outputs.tf                    # Output declarations
    │   ├── provider.tf                   # Provider configuration
    │   ├── terraform.tf                  # Terraform version and backends
    │   ├── vars.tf                       # Main variable declarations
    │   ├── terraform.tfvars.example      # Example variable values (template)
    │   └── deployments/                  # VM deployment configurations
    │       ├── dev.tf                    # Development VMs
    │       ├── test.tf                   # Test VMs
    │       └── prod.tf                   # Production VMs
    └── modules/                          # Reusable Terraform modules
        └── proxmox/                      # Proxmox-specific modules
            └── almalinux9-basic/         # AlmaLinux 9 basic VM module
                ├── main.tf               # Main module configuration
                ├── outputs.tf            # Module outputs
                ├── provider.tf           # Provider requirements
                ├── terraform.tf          # Terraform requirements
                └── vars.tf               # Module variables
```

## Workflow

The typical workflow for using this project consists of two main phases:

### Phase 1: Template Creation with Packer

1. Host kickstart file on GitHub
2. Configure Packer variables
3. Run Packer to build the AlmaLinux 9 template on Proxmox
4. Template is prepared with Cloud-Init for cloning

### Phase 2: VM Deployment with Terraform

1. Configure Terraform variables
2. Choose which environment(s) to deploy (dev, test, prod)
3. Run Terraform to create VMs from the template
4. VMs are automatically configured via Cloud-Init

## Prerequisites

- **Proxmox VE** 7.0 or higher
- **HashiCorp Packer** 1.8.0 or higher
- **HashiCorp Terraform** 1.0.0 or higher
- **GitHub account** for hosting kickstart files
- **Proxmox API token** with appropriate permissions
- **Internet access** from the VM being built (to reach GitHub)

## Quick Start

### Step 1: Clone this repository

```bash
git clone https://github.com/bbzbl-it-joku/Module306-Infrastructure.git
cd Module306-Infrastructure
```

### Step 2: Prepare GitHub Repository

1. Create a new GitHub repository
2. Upload the contents of the `packer/files/kickstart` directory
3. Ensure the repository is public, or set up authentication if private

### Step 3: Create AlmaLinux 9 Template with Packer

1. Configure Packer variables:
   ```bash
   cd packer/config
   cp variables.auto.pkrvars.hcl.example variables.auto.pkrvars.hcl
   # Edit variables.auto.pkrvars.hcl with your specific values
   ```

2. Set sensitive variables in your environment:
   ```bash
   export PKR_VAR_proxmox_api_token_secret="your-token-secret"
   export PKR_VAR_vm_root_pw="your-secure-password"
   ```

3. Run Packer to build the template:
   ```bash
   cd packer
   packer init .
   packer build .
   ```

### Step 4: Deploy VMs with Terraform

1. Configure Terraform variables:
   ```bash
   cd terraform/proxmox
   cp terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars with your specific values
   ```

2. Set sensitive variables in your environment:
   ```bash
   export TF_VAR_proxmox_api_token="your-api-token"
   export TF_VAR_proxmox_user_password="your-password"
   export TF_VAR_vm_sa_user_password="your-service-account-password"
   ```

3. Run Terraform to deploy VMs:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

## Detailed Documentation

For more detailed information, see:

- [Packer Configuration](packer/README.md) - Details on template creation
- [Terraform Configuration](terraform/README.md) - Details on VM deployment

## Network Architecture

This solution works with the following network architectures:

1. **Separate Networks**: Packer host and VM in completely different networks
2. **NAT Environment**: VM behind NAT without direct connectivity to Packer
3. **Air-Gapped Environments**: VM with internet access but no direct route to Packer

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│ Packer Host │     │   GitHub    │     │   Proxmox   │
│             │────▶│  Repository │◀────│     VM      │
└─────────────┘     └─────────────┘     └─────────────┘
    Triggers            Hosts the          Retrieves
     Build            Kickstart File     Kickstart File
```

## Security Considerations

- **API Tokens**: Use restricted-privilege tokens with the minimum necessary permissions
- **Sensitive Variables**: Provide sensitive data via environment variables, not in files
- **SSH Keys**: Consider using SSH key authentication instead of passwords
- **Network Security**: Ensure the VM can only reach necessary external resources
- **Template Hardening**: Consider additional security hardening for production templates

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request
