
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

## Generate The CA Certificate and private key

cat > ca-config.json 
{
  "signing": {
    "default": {
      "expiry": "8760h"
    },
    "profiles": {
      "kubernetes": {
        "usages": ["signing", "key encipherment", "server auth", "client auth"],
        "expiry": "8760h"
      }
    }
  }
}


cat > ca-csr.json
{
  "CN": "Kubernetes",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "IN",
      "L": "Chennai",
      "O": "Kubernetes",
      "OU": "IT",
      "ST": "Tamilnadu"
    }
  ]
}
EOF

## This command   
===># cfssl gencert -initca ca-csr.json | cfssljson -bare ca
### sample output files
- ca-key.pem
- ca.pem

# Client and Server Certificates

In this section you will generate client and server certificates for each Kubernetes component and a client certificate for the Kubernetes `admin` user.

## The Admin Client Certificate

Generate the `admin` client certificate and private key:

-  cat admin-csr.json 
{
    "CN": "admin",
    "key": {
        "algo": "rsa",
        "size": 2048
    },
    "names": [
        {
            "C": "IN",
            "L": "Chennai",
            "O": "system:masters",
            "OU": "IT",
            "ST": "Tamilnadu"
        }
    ]
}
## This command use generate certificate
===>#  cfssl gencert   -ca=ca.pem   -ca-key=ca-key.pem   -config=ca-config.json   -profile=kubernetes   admin-csr.json | cfssljson -bare admin

### sample output
- admin-key.pem
- admin.pem

# The Kubelet Client Certificates
-  Kubernetes uses a special-purpose authorization mode called Node Authorizer, that specifically authorizes API requests made by Kubelets. In order to be authorized by the Node Authorizer, Kubelets must use a credential that identifies them as being in the system:nodes group, with a username of system:node:workernode. In this section you will create a certificate for each Kubernetes worker node that meets the Node Authorizer requirements.
## Generate a certificate and private key for each Kubernetes worker node:
-  cat workernode-csr.json 
{
    "CN": "system:node:workernode",
    "key": {
        "algo": "rsa",
        "size": 2048
    },
    "names": [
        {
            "C": "IN",
            "L": "Chennai",
            "O": "system:nodes",
            "OU": "IT",
            "ST": "Tamilnadu"
        }
    ]
}
## This command 
===># cfssl gencert   -ca=ca.pem   -ca-key=ca-key.pem   -config=ca-config.json   -hostname=workernode,192.168.5.147   -profile=kubernetes   workernode-csr.json | cfssljson -bare workernode
### sample output
- workernode-key.pem
- workernode.pem

#  The Controller Manager Client Certificate

## Generate the kube-controller-manager client certificate and private key:
-  cat kube-controller-manager-csr.json 
{
    "CN": "system:kube-controller-manager",
    "key": {
        "algo": "rsa",
        "size": 2048
    },
    "names": [
        {
            "C": "IN",
            "L": "Chennai",
            "O": "system:kube-controller-manager",
            "OU": "IT",
            "ST": "Tamilnadu"
        }
    ]
}

## This command
===># cfssl gencert   -ca=ca.pem   -ca-key=ca-key.pem   -config=ca-config.json   -profile=kubernetes   kube-controller-manager-csr.json | cfssljson -bare kube-controller-manager
### sample output
- kube-controller-manager-key.pem
- kube-controller-manager.pem
# The Kube Proxy Client Certificate

## Generate the kube-proxy client certificate and private key:
 - cat kube-proxy-csr.json 
{
    "CN": "system:kube-proxy",
    "key": {
        "algo": "rsa",
        "size": 2048
    },
    "names": [
        {
            "C": "IN",
            "L": "Chennai",
            "O": "system:node-proxier",
            "OU": "IT",
            "ST": "Tamilnadu"
        }
    ]
}
## THis command
===># cfssl gencert   -ca=ca.pem   -ca-key=ca-key.pem   -config=ca-config.json   -profile=kubernetes   kube-proxy-csr.json | cfssljson -bare kube-proxy
### sample output
- kube-proxy-key.pem
- kube-proxy.pem

# The Scheduler Client Certificate

## Generate the kube-scheduler client certificate and private key:
- cat kube-scheduler-csr.json 
{
    "CN": "system:kube-scheduler",
    "key": {
        "algo": "rsa",
        "size": 2048
    },
    "names": [
        {
            "C": "IN",
            "L": "Chennai",
            "O": "system:kube-scheduler",
            "OU": "IT",
            "ST": "Tamilnadu"
        }
    ]
}
## THis command
===># cfssl gencert   -ca=ca.pem   -ca-key=ca-key.pem   -config=ca-config.json   -profile=kubernetes   kube-scheduler-csr.json | cfssljson -bare kube-scheduler

### Sample output
- kube-scheduler-key.pem
- kube-scheduler.pem

# The Kubernetes API Server Certificate

The kubernetes-the-hard-way static IP address will be included in the list of subject alternative names for the Kubernetes API Server certificate. This will ensure the certificate can be validated by remote clients.

## Generate the Kubernetes API Server certificate and private key:
- cat kubernetes-csr.json 
{
    "CN": "kubernetes",
    "key": {
        "algo": "rsa",
        "size": 2048
    },
    "names": [
        {
            "C": "IN",
            "L": "Chennai",
            "O": "Kubernetes",
            "OU": "IT",
            "ST": "Tamilnadu"
        }
    ]
}

## This command
===># cfssl gencert   -ca=ca.pem   -ca-key=ca-key.pem   -config=ca-config.json   -hostname=192.168.5.146   -profile=kubernetes   kubernetes-csr.json | cfssljson -bare kubernetes

### sample output
- kubernetes-key.pem
- kubernetes.pem

# The Service Account Key Pair

The Kubernetes Controller Manager leverages a key pair to generate and sign service account tokens as described in the managing service accounts documentation.

## Generate the service-account certificate and private key:

- cat service-account-csr.json 
{
    "CN": "service-accounts",
    "key": {
        "algo": "rsa",
        "size": 2048
    },
    "names": [
        {
            "C": "IN",
            "L": "Chennai",
            "O": "Kubernetes",
            "OU": "IT",
            "ST": "Tamilnadu"
        }
    ]
}

## This command 
===># cfssl gencert   -ca=ca.pem   -ca-key=ca-key.pem   -config=ca-config.json   -profile=kubernetes   service-account-csr.json | cfssljson -bare service-account
### Sample output
- service-account-key.pem
- service-account.pem

# Distribute the Client and Server Certificates

## Copy the appropriate certificates and private keys to each worker nodes: 
- copy These file workernode and kube-proxy = wokernode
## Copy the appropriate certificates and private keys to each controller :
- copy admin.kubeconfig kube-controller-manager.kubeconfig kube-scheduler.kubeconfig = masternode
