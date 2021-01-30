# kubectl
 kubectl is the kubernetes command line tool. It allows us to interact with kubernetes cluster from the command line.

## Configuring kubectl for Remote Access
In this lab you will generate a kubeconfig file for the kubectl command line utility based on the admin user credentials.
```
KUBERNETES_PUBLIC_ADDRESS= Loadbalancer
```
```
  kubectl config set-cluster kubernetes-the-hard-way \
    --certificate-authority=ca.pem \
    --embed-certs=true \
    --server=https://api.mylap.in

  kubectl config set-credentials admin \
    --client-certificate=admin.pem \
    --client-key=admin-key.pem

  kubectl config set-context kubernetes-the-hard-way \
    --cluster=kubernetes-the-hard-way \
    --user=admin

  kubectl config use-context kubernetes-the-hard-way
```
## Verification
Check the health of the remote Kubernetes cluster:
```
kubectl get componentstatuses

Results

NAME                 STATUS    MESSAGE             ERROR
scheduler            Healthy   ok                  
controller-manager   Healthy   ok                  
etcd-1               Healthy   {"health":"true"}   
etcd-0               Healthy   {"health":"true"}   

```
List the nodes in the remote Kubernetes cluster:
```
kubectl get nodes

NAME               STATUS   ROLES    AGE   VERSION
worker1.mylap.in   Ready    <none>   22h   v1.20.0
```
