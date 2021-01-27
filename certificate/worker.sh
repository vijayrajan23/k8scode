#!/bin/bash
# wokernode certificates move
for instance in worker1.mylap.in worker2.mylap.in; do
  scp ca.pem ${instance}-key.pem ${instance}.pem ${instance}.kubeconfig kube-proxy.kubeconfig  ${instance}:~/
done
