#!/bin/bash
#==============================================================================
# VM Template Cleanup Script
#==============================================================================
# Purpose: Clean up the VM before converting to a template
# Author:  Joshua Kunz
# Date:    April 20, 2025
# Version: 1.0
#
# This script:
# - Removes unique identifiers and logs
# - Cleans up package cache
# - Resets Cloud-Init
# - Ensures proper templating for Proxmox
#==============================================================================

# Exit on error
set -e

# Log function
log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a /root/template-cleanup.log
}

log "Starting template cleanup process"

#------------------------------------------------------------------------------
# Remove SSH host keys
#------------------------------------------------------------------------------
log "Removing SSH host keys"
rm -f /etc/ssh/ssh_host_*
# Add a Cloud-Init job to regenerate SSH host keys on first boot
cat > /etc/cloud/cloud.cfg.d/20-regenerate-ssh-host-keys.cfg <<EOF
# Regenerate SSH host keys on first boot
ssh_deletekeys: True
ssh_genkeytypes: ['rsa', 'ecdsa', 'ed25519']
EOF

#------------------------------------------------------------------------------
# Clean machine-specific identifiers
#------------------------------------------------------------------------------
log "Cleaning machine-specific identifiers"
# Remove machine ID - will be regenerated on first boot
truncate -s 0 /etc/machine-id
rm -f /var/lib/dbus/machine-id
ln -sf /etc/machine-id /var/lib/dbus/machine-id

# Remove persistent network rules if they exist
rm -f /etc/udev/rules.d/70-persistent-net.rules
rm -f /etc/udev/rules.d/70-persistent-cd.rules

#------------------------------------------------------------------------------
# Clean package cache and logs
#------------------------------------------------------------------------------
log "Cleaning package cache and logs"
# Clean DNF cache
dnf clean all
rm -rf /var/cache/dnf

# Remove temporary files
rm -rf /tmp/* /var/tmp/*

# Clean log files
find /var/log -type f -exec truncate -s 0 {} \;
rm -f /var/log/audit/*
rm -f /root/.bash_history

#------------------------------------------------------------------------------
# Reset Cloud-Init state
#------------------------------------------------------------------------------
log "Resetting Cloud-Init state"
# Remove cloud-init state
cloud-init clean --logs

# Remove cloud-init instance data
rm -rf /var/lib/cloud/instances/*

# Remove installer-related files
rm -f /root/anaconda-ks.cfg
rm -f /root/original-ks.cfg
rm -f /root/install.log
rm -f /root/install.log.syslog

#------------------------------------------------------------------------------
# Remove this script before finishing
#------------------------------------------------------------------------------
log "Template cleanup completed successfully"
# Remove the copied script
rm -f /tmp/setup-cloud-init.sh
rm -f /tmp/cleanup.sh

# Sync filesystem to ensure all changes are written
sync

exit 0