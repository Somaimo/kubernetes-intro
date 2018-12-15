#!/usr/bin/env bash

# This script is expected to be run as root through sudo for example.

#let's disable SWAP (docker does not like that)
swapoff -a
sed -i '/swap/s' /etc/fstab

# first make sure our sources are up to date
apt-get update

# next add the docker stuff
apt-get -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

# download pgp public keys for the docker repo
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

# add docker repo
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

# update sources
apt-get update

# install docker
apt-get -y install docker-ce

# add normal user based on environment variables
if [ -v ADMINUSERNAME ] && [ -v ADMINPASSWORD ]; then
    adduser --quiet $ADMINUSERNAME --ingroup adm --gecos "marco" --disable-password
    echo "$ADMINUSERNAME:$ADMINPASSWORD" | chpasswd
    adduser $ADMINUSERNAME adm
    adduser $ADMINUSERNAME docker
fi

## Finished with the Docker install. Now kubeadm
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

#add kubeneretes repository
add-apt-repository \
   "deb [arch=amd64] https://apt.kubernetes.io/ kubernetes-xenial main"

# Install kubeadm and kubectl
apt-get install -y kubelet kubeadm kubectl

# Hold currently installed kubeadm and kublet version
apt-mark hold kubelet kubeadm kubectl

echo "All Done!"

# all done