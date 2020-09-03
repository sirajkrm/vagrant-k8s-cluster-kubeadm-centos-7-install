#!/bin/bash

# Update hosts file
echo "[TASK 1] Update /etc/hosts file"
cat >>/etc/hosts<<EOF
172.25.0.10 k8score.lab.local k8score
172.25.0.11 k8sworker1.lab.local k8sworker1
172.25.0.12 k8sworker2.lab.local k8sworker2
EOF

# Disable SELinux
echo "[TASK 2] Disable SELinux"
setenforce 0
sed -i --follow-symlinks 's/^SELINUX=enforcing/SELINUX=disabled/' /etc/sysconfig/selinux

# Firewall Rules
echo "[TASK 3] Firewall Rules to allow necessary ports"
systemctl enable firewalld
systemctl start firewalld
firewall-cmd --permanent --add-port=6443/tcp
firewall-cmd --permanent --add-port=2379-2380/tcp
firewall-cmd --permanent --add-port=10250-10253/tcp
firewall-cmd --permanent --add-port=10255/tcp
firewall-cmd --reload
modprobe br_netfilter
echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables

# Letting iptables see bridged traffic
echo "[TASK 4] Letting iptables see bridged traffic"
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sudo sysctl --system

# Disable swap
echo "[TASK 5] Disable and turn off SWAP"
sed -i '/swap/d' /etc/fstab
swapoff -a

# Enable ssh password authentication
echo "[TASK 6] Enable ssh password authentication"
sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
systemctl reload sshd

# Install docker from Docker-ce repository
echo "[TASK 7] Install Docker CE"
yum install -y -q device-mapper-persistant-data lvm2 yum-utils > /dev/null 2>&1
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo > /dev/null 2>&1
yum install -y -q docker-ce docker-ce-cli containerd.io >/dev/null 2>&1

echo "[TASK 8] Enable and start docker service"
systemctl enable docker >/dev/null 2>&1
systemctl restart docker

# Add yum repo file for Kubernetes
echo "[TASK 9] Add yum repo file for kubernetes"
cat >>/etc/yum.repos.d/kubernetes.repo<<EOF
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
  https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

# Update and Install Kubernetes
echo "[TASK 10] Install Kubernetes (kubeadm, kubelet and kubectl)"
yum update -y -q
sleep 30
yum install -y kubeadm kubelet kubectl >/dev/null 2>&1

# Start and Enable kubelet service
echo "[TASK 11] Enable and start kubelet service"
systemctl enable kubelet >/dev/null 2>&1
systemctl start kubelet >/dev/null 2>&1

# enable bash completion
echo "[TASK 12] Enabling Bash Completion"
source <(kubectl completion bash)
echo "source <(kubectl completion bash)" >> ~/.bashrc

