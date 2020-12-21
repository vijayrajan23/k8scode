#  Kubeconfig 
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