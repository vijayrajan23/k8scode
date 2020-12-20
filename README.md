# k8scode

kubernetes server

###controller components###

-   etcd
-   kube-apiserver
-   nginx
-   kube-controller-manager
-   kube-scheduler

###Nod components###

-   containerd and container d services
-   kubelet (controller passing instruction nod or worker getting via kubelet)
-   kube proxy

### Certificate Authority (CA)

-   Certificates are used to confrom authenticate identity.
-   CA provides the ability to confrom that certificate is valid. CA can be validate certificate tha was issued using that CA.
-   kubernet uses certificates for a variety of security funcations, and different parts of kubernet cluster will validate certificates using the CA.
