#!/bin/bash
# master certificates move
for instance in master1.mylap.in master2.mylap.in; do
  scp ca.pem ca-key.pem kubernetes-key.pem kubernetes.pem service-account-key.pem service-account.pem \
     admin.kubeconfig kube-controller-manager.kubeconfig kube-scheduler.kubeconfig encryption-config.yaml etcd.sh	  ubuntu@${instance}:~/k8s/
done
