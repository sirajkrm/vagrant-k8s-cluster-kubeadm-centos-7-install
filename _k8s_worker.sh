#!/bin/bash

# Join worker nodes to the Kubernetes cluster
echo "[TASK 1] Join node to Kubernetes Cluster"
yum install -y sshpass >/dev/null 2>&1
sshpass -p "vagrant" scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no k8score.lab.local:/opt/join.sh /opt/join.sh 2>/dev/null

bash /opt/join.sh
