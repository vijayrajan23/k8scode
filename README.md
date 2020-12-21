#####                    Kubernet Cluster           #####

# Kubernetes server

# Controller components

-   etcd
-   kube-apiserver
-   nginx
-   kube-controller-manager
-   kube-scheduler

# Nod components

-   containerd and container d services
-   kubelet (controller passing instruction nod or worker getting via kubelet)
-   kube proxy
#  Certifcate part
- Refer to certificate.md and certificate folders.
#  Kubeconfig 
-A Kubernetes configuration or kubeconfig  is that stores information about clusters, users, namesapce, pods, services and authentication meschanisms, (I) Location  of the cluster you want to connect, (II) what user you want to authenticate, (III) Data needed in order to authenticate, such as tokens or client certificates.