# Generating Kubernetes Configuration Files for Authentication

#  Client Authentication Configs
- A Kubernetes configuration or kubeconfig  is that stores information about clusters, users, namesapce, pods, services and authentication meschanisms, (I) Location  of the cluster you want to connect, (II) what user you want to authenticate, (III) Data needed in order to authenticate, such as tokens or client certificates.

# Kubeconfig generate.
- kubelet (one for each worker node)
- kube proxy
- kube-controller-manager
- kube-scheduler
- Admin
## kubeconfig file generate
- file path = certificate path.
## Generating kubeconfig for kubelet all worker nodes.
- In This scenario the worknode kubelet and kube-proxy not connect directly controller, its connting via kube-API-loadbalancer (nginx).
## code
for instance in workernodes; do
  kubectl config set-cluster kubernetes-the-hard-way \
    --certificate-authority=ca.pem \
    --embed-certs=true \
    --server=https://${kube-API-loadbalancer-IP}:6443 \
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
### sample output
- workernodes.kubeconfig
# The kube-proxy Kubernetes Configuration File

## Generate a kubeconfig file for the kube-proxy service:
## code
{
  kubectl config set-cluster kubernetes-the-hard-way \
    --certificate-authority=ca.pem \
    --embed-certs=true \
    --server=https://${kube-API-loadbalancer-IP}:6443 \
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
### sample Output
- kube-proxy.kubeconfig

# The kube-controller-manager Kubernetes Configuration File

## Generate a kubeconfig file for the kube-controller-manager service:
- kube-controller-manager connectiong via kube-API-server same controller use localloop ip 
## code
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
### sample output
- kube-controller-manager.kubeconfig

# The kube-scheduler Kubernetes Configuration File

## Generate a kubeconfig file for the kube-scheduler service:
- kube-scheduler get instruction etcd same controller use localloop ip
## code
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
### sample output
- kube-scheduler.kubeconfig

# The admin Kubernetes Configuration File

## Generate a kubeconfig file for the admin user:
## code
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
### sample output
- admin.kubeconfig
#  Distribute the Kubernetes Configuration Files
- worker node
- copy these configfiles workernode.kubeconfig, kube-proxy.kubeconfig to workernode.
- Controller node
- copy these configfiles admin.kubeconfig, kube-controller-manager.kubeconfig, kube-scheduler.kubeconfig to controllernode.