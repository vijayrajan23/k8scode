# Generating Kubernetes Configuration Files for Authentication
#  Client Authentication Configs
- A Kubernetes configuration or kubeconfig  is that stores information about clusters, users, namesapce, pods, services and authentication meschanisms, (I) Location  of the cluster you want to connect, (II) what user you want to authenticate, (III) Data needed in order to authenticate, such as tokens or client certificates.
# Kubeconfig generate.
```* kubelet *** (for each worker node) ```
```* kube proxy ```
```* kube-controller-manager ```
```* kube-scheduler ```
```* Admin```
## kubeconfig file generate
## Generating kubeconfig for kubelet all worker nodes.
In This scenario the worknode kubelet and kube-proxy not connect directly controller, its connting via kube-API-loadbalancer (nginx).
### Command use generate ConfigFile. 
```
 KUBERNETES_ADDRESS=192.168.5.104

for instance in  worker1.mylap.in worker2.mylap.in; do
  kubectl config set-cluster kubernetes-the-hard-way \
    --certificate-authority=ca.pem \
    --embed-certs=true \
    --server=https://${KUBERNETES_ADDRESS}:6443 \
    --kubeconfig=${instance}.kubeconfig

  kubectl config set-credentials system:node:${instance} \
    --client-certificate=${instance}.pem \
    --client-key=${instance}-key.pem \
    --embed-certs=true \
    --kubeconfig=${instance}.kubeconfig

  kubectl config set-context default \
    --cluster=kubernetes-the-hard-way \
    --user=system:node:${instance} \
    --kubeconfig=${instance}.kubeconfig

  kubectl config use-context default --kubeconfig=${instance}.kubeconfig
done
```
### Results
```
worker1.mylap.in.kubeconfig
worker2.mylap.in.kubeconfig
```
# The kube-proxy Kubernetes Configuration File
## Generate a kubeconfig file for the kube-proxy service:
### Command use generate ConfigFile.
```
{
  kubectl config set-cluster kubernetes-the-hard-way \
    --certificate-authority=ca.pem \
    --embed-certs=true \
    --server=https://${KUBERNETES_ADDRESS}:6443 \
    --kubeconfig=kube-proxy.kubeconfig

  kubectl config set-credentials system:kube-proxy \
    --client-certificate=kube-proxy.pem \
    --client-key=kube-proxy-key.pem \
    --embed-certs=true \
    --kubeconfig=kube-proxy.kubeconfig

  kubectl config set-context default \
    --cluster=kubernetes-the-hard-way \
    --user=system:kube-proxy \
    --kubeconfig=kube-proxy.kubeconfig

  kubectl config use-context default --kubeconfig=kube-proxy.kubeconfig
}
```
### Results
```
kube-proxy.kubeconfig
```
# The kube-controller-manager Kubernetes Configuration File
## Generate a kubeconfig file for the kube-controller-manager service:
 kube-controller-manager connectiong via kube-API-server same controller use localloop ip 
## Command use generate ConfigFile.
```
{
  kubectl config set-cluster kubernetes-the-hard-way \
    --certificate-authority=ca.pem \
    --embed-certs=true \
    --server=https://127.0.0.1:6443 \
    --kubeconfig=kube-controller-manager.kubeconfig

  kubectl config set-credentials system:kube-controller-manager \
    --client-certificate=kube-controller-manager.pem \
    --client-key=kube-controller-manager-key.pem \
    --embed-certs=true \
    --kubeconfig=kube-controller-manager.kubeconfig

  kubectl config set-context default \
    --cluster=kubernetes-the-hard-way \
    --user=system:kube-controller-manager \
    --kubeconfig=kube-controller-manager.kubeconfig

  kubectl config use-context default --kubeconfig=kube-controller-manager.kubeconfig
}
```
### Results
```
kube-controller-manager.kubeconfig
```
# The kube-scheduler Kubernetes Configuration File
## Generate a kubeconfig file for the kube-scheduler service:
kube-scheduler get instruction etcd same controller use localloop ip
## Command use generate ConfigFile.
```
{
  kubectl config set-cluster kubernetes-the-hard-way \
    --certificate-authority=ca.pem \
    --embed-certs=true \
    --server=https://127.0.0.1:6443 \
    --kubeconfig=kube-scheduler.kubeconfig

  kubectl config set-credentials system:kube-scheduler \
    --client-certificate=kube-scheduler.pem \
    --client-key=kube-scheduler-key.pem \
    --embed-certs=true \
    --kubeconfig=kube-scheduler.kubeconfig

  kubectl config set-context default \
    --cluster=kubernetes-the-hard-way \
    --user=system:kube-scheduler \
    --kubeconfig=kube-scheduler.kubeconfig

  kubectl config use-context default --kubeconfig=kube-scheduler.kubeconfig
}
```
### Results
```
kube-scheduler.kubeconfig
```
# The admin Kubernetes Configuration File
## Generate a kubeconfig file for the admin user:
## Command use generate ConfigFile.
```
{
  kubectl config set-cluster kubernetes-the-hard-way \
    --certificate-authority=ca.pem \
    --embed-certs=true \
    --server=https://127.0.0.1:6443 \
    --kubeconfig=admin.kubeconfig

  kubectl config set-credentials admin \
    --client-certificate=admin.pem \
    --client-key=admin-key.pem \
    --embed-certs=true \
    --kubeconfig=admin.kubeconfig

  kubectl config set-context default \
    --cluster=kubernetes-the-hard-way \
    --user=admin \
    --kubeconfig=admin.kubeconfig

  kubectl config use-context default --kubeconfig=admin.kubeconfig
}
```
### Results
``` admin.kubeconfig ```
#  Distribute the Kubernetes Configuration Files
```* worker node ```
```* copy these configfiles workernode.kubeconfig, kube-proxy.kubeconfig to workernode. ```
```* Controller node ```
```* copy these configfiles admin.kubeconfig, kube-controller-manager.kubeconfig, kube-scheduler.kubeconfig to controllernode. ```
```
#!/bin/bash
# wokernode certificates move
for instance in worker1.mylap.in worker2.mylap.in; do
  scp  ${instance}.kubeconfig kube-proxy.kubeconfig  user@${instance}:~/k8s/
done
```

```
#!/bin/bash
# master certificates move
for instance in master1.mylap.in master2.mylap.in; do
  scp admin.kubeconfig kube-controller-manager.kubeconfig kube-scheduler.kubeconfig	  ubuntu@${instance}:~/k8s/
done
```
