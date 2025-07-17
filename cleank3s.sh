#!/bin/bash

sudo rm -rf /etc/rancher
sudo rm -rf /var/lib/rancher
sudo rm -rf /var/lib/kubelet
sudo rm -rf /var/lib/cni
sudo rm -rf /run/k3s
sudo rm -rf /etc/cni
sudo rm -rf /opt/cni
sudo rm -rf /var/run/flannel
sudo rm -rf /etc/kubernetes

rm -f ~/.kube/config

sudo ip link delete cni0 2>/dev/null || true
sudo ip link delete flannel.1 2>/dev/null || true

