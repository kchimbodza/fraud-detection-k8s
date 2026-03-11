#!/bin/bash

ISO="/home/kc/ubuntu-22.04.5-live-server-amd64.iso"
IMG_DIR="/var/lib/libvirt/images"

echo "Creating k3s-control..."
sudo virt-install \
  --name k3s-control \
  --ram 3072 \
  --vcpus 2 \
  --disk path=$IMG_DIR/k3s-control.qcow2,size=15 \
  --os-variant ubuntu22.04 \
  --network bridge=virbr0 \
  --cdrom $ISO \
  --noautoconsole

echo "Creating k3s-worker-1..."
sudo virt-install \
  --name k3s-worker-1 \
  --ram 4096 \
  --vcpus 3 \
  --disk path=$IMG_DIR/k3s-worker-1.qcow2,size=15 \
  --os-variant ubuntu22.04 \
  --network bridge=virbr0 \
  --cdrom $ISO \
  --noautoconsole

echo "Creating k3s-worker-2..."
sudo virt-install \
  --name k3s-worker-2 \
  --ram 4096 \
  --vcpus 3 \
  --disk path=$IMG_DIR/k3s-worker-2.qcow2,size=15 \
  --os-variant ubuntu22.04 \
  --network bridge=virbr0 \
  --cdrom $ISO \
  --noautoconsole

echo "All VMs created. Checking status..."
sudo virsh list --all
