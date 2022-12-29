#!/bin/bash
set -eux

cd `dirname ${0}`
cd ../terraform

terraform init
terraform apply  -auto-approve -var-file=main.tfvars
terraform output

TF_OUTPUT=$(terraform output -json)
MASTER_IP=$(echo $TF_OUTPUT | jq -r '.master_ip.value')
MASTER_HOSTNAME=$(echo $TF_OUTPUT | jq -r '.master_hostname.value')
MASTER_SUBNET_DNS_LABEL=$(echo $TF_OUTPUT | jq -r '.master_subnet_dns_label.value')
VCN_DNS_LABEL=$(echo $TF_OUTPUT | jq -r '.vcn_dns_label.value')
WORKER_IP=$(echo $TF_OUTPUT | jq -r '.worker_ip.value')
WORKER_HOSTNAME=$(echo $TF_OUTPUT | jq -r '.worker_hostname.value')
WORKER_IP2=$(echo $TF_OUTPUT | jq -r '.worker_ip2.value')
WORKER_HOSTNAME2=$(echo $TF_OUTPUT | jq -r '.worker_hostname2.value')
OS_USER=$(echo $TF_OUTPUT | jq -r '.os_user.value')
SSH_PRIVATE_KEY=$(echo $TF_OUTPUT | jq -r '.ssh_private_key_path.value')

MASTER_FQDN="${MASTER_HOSTNAME}.${MASTER_SUBNET_DNS_LABEL}.${VCN_DNS_LABEL}.oraclevcn.com"

cat > ../ansible-kubeadm/hosts.ini << EOF
[master]
${MASTER_HOSTNAME} ansible_host=${MASTER_IP}

[worker]
${WORKER_HOSTNAME} ansible_host=${WORKER_IP}
${WORKER_HOSTNAME2} ansible_host=${WORKER_IP2}

[kube_cluster:children]
master
worker

[all:vars]
ansible_user=${OS_USER}
control_plane_endpoint_ip=${MASTER_FQDN}
ansible_ssh_private_key_file=${SSH_PRIVATE_KEY}

EOF

cp ../ansible-kubeadm/hosts.ini ../ansible-k3s/hosts.ini

cat > ../hosts-sample <<EOF
${MASTER_IP}  ${MASTER_FQDN}
EOF
