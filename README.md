# kubernetes-on-oci-free-tier
Setup Kubernetes on OCI Free Tier

# Requirements

|Tool|Version|
|---|---|
|Terraform|1.3.6 (tested)|
|Ansible|2.11.12 (tested)|
|jq|1.6|

# How To

## Create main.tfvars

```bash
cp terraform/main.tfvars.example terraform/main.tfvars
```
Set the parameters.

## add SSH Private key to ssh-agent (if need)

```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa-for-oci
```

## Create Cluster

### kubeadm
```bash
./bin/setup-by-kubeadm.sh
```

### k3s
```bash
./bin/setup-by-k3s.sh
```

## Set kubeconfig

```bash
mv ~/admin.conf ~/.kube/config
```

You are able to access Kubernetes Cluster.

## Destroy Cluster
```bash
./bin/destroy.sh
```