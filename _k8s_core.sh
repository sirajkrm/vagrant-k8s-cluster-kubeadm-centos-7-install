#!/bin/bash

# Initialize Kubernetes
echo "[TASK 1] Initialize Kubernetes Cluster"
kubeadm init --apiserver-advertise-address=172.25.0.10 --pod-network-cidr=10.244.0.0/16 >> /root/kubeinit.log 2>/dev/null

# Use cluster as root
echo "[TASK 2] Use Cluster as root"
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

# Deploy Weavenet network
echo "[TASK 3] Deploy Weavenet Network"
export kubever=$(kubectl version | base64 | tr -d '\n')
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$kubever"

# Verify status
echo "[TASK 4] Verify status of Core Node"
sleep 80
kubectl get nodes
kubectl get pods  --all-namespaces

# Generate Cluster join command
echo "[TASK 5] Generate and save cluster join command"
kubeadm token create --print-join-command > /opt/join.sh
echo "######## JOIN Command ########"
cat /opt/join.sh
sleep 20
echo "######## JOIN Command ########"

#remove warning msg
#sed 1d /opt/join.sh

chmod 755 /opt/join.sh
