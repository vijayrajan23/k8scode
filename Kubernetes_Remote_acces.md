### What is kubectl?
 
 - kubectl is the kubernetes command line tool. It allows us to interact with kubernetes cluster from the command line.

## Configuring kubectl for Remote Access

- In this lab you will generate a kubeconfig file for the kubectl command line utility based on the admin user credentials.


  KUBERNETES_PUBLIC_ADDRESS=$(gcloud compute addresses describe kubernetes-the-hard-way \
   
    --region $(gcloud config get-value compute/region) \
   
    --format 'value(address)')

  kubectl config set-cluster kubernetes-the-hard-way \
   
    --certificate-authority=ca.pem \
   
    --embed-certs=true \
   
    --server=https://${KUBERNETES_PUBLIC_ADDRESS}:6443

  kubectl config set-credentials admin \
   
    --client-certificate=admin.pem \
   
    --client-key=admin-key.pem

  kubectl config set-context kubernetes-the-hard-way \
   
    --cluster=kubernetes-the-hard-way \
   
    --user=admin

  kubectl config use-context kubernetes-the-hard-way

## Verification

- Check the health of the remote Kubernetes cluster:

$$ kubectl get componentstatuses

- List the nodes in the remote Kubernetes cluster:

$$ kubectl get nodes