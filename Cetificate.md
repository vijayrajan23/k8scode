
# Certificate Authority (CA)

-   Certificates are used to confrom authenticate identity.
-   CA provides the ability to confrom that certificate is valid. CA can be validate certificate tha was issued using that CA.
-   kubernet uses certificates for a variety of security funcations, and different parts of kubernet cluster will validate certificates using the CA.

## what are certificate do we need ##

# Client Certificates

-  These certificate provide client authentication for various users: admin, kube-controller-manager, kube-proxy, kube-scheduler and kubelet client on each worker node.

# kubernet API Server Certificate

- This is the TLS certificate for the kubernet API.

# Service Account Key Pair

- Kubernet uses a certificate to sign service account tokens