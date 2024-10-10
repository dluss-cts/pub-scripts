#!/bin/bash

# set inputs
export SUBSCRIPTION_ID=$0
export RESOURCE_GROUP_NAME=$1
export CLUSTER_NAME=$2

subscription_id=$0
resource_group_name=$1
cluster_name=$2

# install kubectl

sudo apt-get update

# apt-transport-https may be a dummy package; if so, you can skip that package
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg

# If the folder `/etc/apt/keyrings` does not exist, it should be created before the curl command, read the note below.
sudo mkdir -p -m 755 /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg # allow unprivileged APT programs to read this keyring

# This overwrites any existing configuration in /etc/apt/sources.list.d/kubernetes.list
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list   # helps tools such as command-not-found to work correctly

sudo apt-get update
sudo apt-get install -y kubectl 


## install az cli 
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

## Login to az and cluster:

az login --identity 

az account set --subscription $subscription_id

az aks get-credentials --resource-group $resource_group_name --name $cluster_name --overwrite-existing --admin --format azure

az aks install-cli

az login

export KUBECONFIG=~/.kube/config

kubelogin convert-kubeconfig -l azurecli

kubectl get nodes


# # install turbine

# curl -Lo kots.tar.gz https://get.swimlane.io/existing-cluster/install/linux

# tar zxf kots.tar.gz

# mv kots /usr/local/bin/kubectl-kots

# kubectl kots install turbine --namespace your-namespace  --kubeconfig /path/to/kube/config

# kubectl kots admin-console --namespace turbine
