#!/bin/bash

# Check for correct number of arguments
if [ "$#" -ne 5 ]; then
  echo "Usage: $0 <org_id> <location_id> <dns_domain> <control_ip> <daemon_ip>"
  exit 1
fi

# Assign parameters to variables
org_id="$1"
location_id="$2"
dns_domain="$3"
control_ip="$4"
daemon_ip="$5"
dns_zone="${dns_domain%%.*}"

# Replace strings in the files
echo "replacing data"
# Update Certificate configuration
sed -i "s/laconic\.com/${dns_domain}/g" files/manifests/wildcard-pwa-laconic.yaml
mv files/manifests/wildcard-pwa-laconic.yaml files/manifests/wildcard-pwa-${dns_zone}.yaml

# Update k8s-vault.yml
mkdir -p "group_vars/${org_id}_${location_id}" && mv group_vars/lcn_cad/k8s-vault.yml "group_vars/${org_id}_${location_id}/k8s-vault.yml"

# Update k8s.yml
sed -i "s/lcn-cad-cluster/${org_id}-${location_id}-cluster/g" group_vars/lcn_cad/k8s.yml
sed -i "s/laconic\.com/${dns_domain}/g" group_vars/lcn_cad/k8s.yml
sed -i "s/wildcard-pwa-laconic\.yaml/wildcard-pwa-${dns_zone}\.yaml/g" group_vars/lcn_cad/k8s.yml
mv group_vars/lcn_cad/k8s.yml "group_vars/${org_id}_${location_id}/k8s.yml"

# Update firewalld.yml for lcn-cad-cluster-control and lcn-daemon
sed -i "s/159\.203\.31\.82\/32/${control_ip}\/32/g" host_vars/lcn-cad-cluster-control/firewalld.yml
sed -i "s/147\.182\.144\.6\/32/${daemon_ip}\/32/g" host_vars/lcn-daemon/firewalld.yml
mkdir -p "host_vars/${org_id}-${location_id}-cluster-control" && mv host_vars/lcn-cad-cluster-control/firewalld.yml "host_vars/${org_id}-${location_id}-cluster-control/firewalld.yml"
mkdir -p "host_vars/${org_id}-daemon" && mv host_vars/lcn-daemon/firewalld.yml "host_vars/${org_id}-daemon/firewalld.yml"

# Update nginx.yml for lcn-daemon
sed -i "s/lcn-console/${org_id}-console/g" host_vars/lcn-daemon/nginx.yml
sed -i "s/laconic\.com/${dns_domain}/g" host_vars/lcn-daemon/nginx.yml
sed -i "s/lcn-daemon/${org_id}-daemon/g" host_vars/lcn-daemon/nginx.yml
sed -i "s/laconic\.com/${dns_domain}/g" host_vars/lcn-daemon/nginx.yml
sed -i "s/https:\/\/webapp-deployer\.pwa\.laconic\.com/https:\/\/webapp-deployer\.pwa\.${dns_domain}/g" host_vars/lcn-daemon/nginx.yml
mv host_vars/lcn-daemon/nginx.yml "host_vars/${org_id}-daemon/nginx.yml"

# Update hosts file
sed -i "s/159\.203\.31\.82/${daemon_ip}/g" hosts
sed -i "s/147\.182\.144\.6/${control_ip}/g" hosts
sed -i "s/lcn/${org_id}/g" hosts
sed -i "s/cad/${location_id}/g" hosts
echo "removing unnecessary folders"
rm -rf group_vars/lcn_cad && rm -rf host_vars/lcn-daemon rm -rf host_vars/lcn-cad-cluster-control/
echo "Changes applied successfully!"

