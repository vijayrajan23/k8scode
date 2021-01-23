# what is kubernetes control plane?

- The kubernetes control plane is a set service that control the kubernetes cluster.

- Control plane components make global decisions about the cluster (ex; Scheduling ) and detect respond to cluster events(ex; starting up a new pod when a replication controllers replicas field is unspecified.

## Kubernetes Control Plane components

- The kubernets control plane consist of the following components

* Kube-APIserver: This allows users to interact with the cluster.

* etcd: Kubernetes cluster datastore.

* kube-scheduler: Schedules pods on available worker nodes.

* kube-controller-manager: Runs a series of controllers that provide a wide range funcation.

* colud-controller-manager: Handles interaction with underlying cloud providers.

## Installing kubernetes control plane binaries

* Kube-APIserver, Kube-Scheduler, Kubectl, Kube-controller-manager. Thouse service binaries download to masternode.

## Create the Kubernetes configuration directory:

- sudo mkdir -p /etc/kubernetes/config

## Download Links and commands.

wget -q --show-progress --https-only --timestamping \

  "https://storage.googleapis.com/kubernetes-release/release/v1.18.6/bin/linux/amd64/kube-apiserver" \

  "https://storage.googleapis.com/kubernetes-release/release/v1.18.6/bin/linux/amd64/kube-controller-manager" \

  "https://storage.googleapis.com/kubernetes-release/release/v1.18.6/bin/linux/amd64/kube-scheduler" \

  "https://storage.googleapis.com/kubernetes-release/release/v1.18.6/bin/linux/amd64/kubectl"

## Install the kubernets binaries.

-   chmod +x kube-apiserver kube-controller-manager kube-scheduler kubectl
-   sudo mv kube-apiserver kube-controller-manager kube-scheduler kubectl /usr/local/bin/

## Configure the kube-apiserver

- Create directory for openssl certificate file.
*   sudo mkdir -p /var/lib/kubernetes/
- Copy Thouse certifacte file.
 sudo mv ca.pem ca-key.pem kubernetes-key.pem kubernetes.pem \

    service-account-key.pem service-account.pem \

    encryption-config.yaml /var/lib/kubernetes/

## The instance internal IP address will be used to advertise the API Server to members of the cluster. Retrieve the internal IP address for the current compute instance

- Master1  and Master2 IPs.

## Create the kube-apiserver.service systemd unit file:

vim /etc/systemd/system/kube-apiserver.service

[Unit]

Description=Kubernetes API Server

Documentation=https://github.com/kubernetes/kubernetes

[Service]

ExecStart=/usr/local/bin/kube-apiserver \\

  --advertise-address=${Master local ip} \\

  --allow-privileged=true \\

  --apiserver-count=3 \\

  --audit-log-maxage=30 \\

  --audit-log-maxbackup=3 \\

  --audit-log-maxsize=100 \\

  --audit-log-path=/var/log/audit.log \\

  --authorization-mode=Node,RBAC \\

  --bind-address=0.0.0.0 \\

  --client-ca-file=/var/lib/kubernetes/ca.pem \\

  --enable-admission-plugins=NamespaceLifecycle,NodeRestriction,LimitRanger,ServiceAccount,DefaultStorageClass,ResourceQuota \\

  --etcd-cafile=/var/lib/kubernetes/ca.pem \\

  --etcd-certfile=/var/lib/kubernetes/kubernetes.pem \\

  --etcd-keyfile=/var/lib/kubernetes/kubernetes-key.pem \\

  --etcd-servers=https://Master1:2379,https://Master2:2379 \\

  --event-ttl=1h \\

  --encryption-provider-config=/var/lib/kubernetes/encryption-config.yaml \\

  --kubelet-certificate-authority=/var/lib/kubernetes/ca.pem \\

  --kubelet-client-certificate=/var/lib/kubernetes/kubernetes.pem \\

  --kubelet-client-key=/var/lib/kubernetes/kubernetes-key.pem \\

  --kubelet-https=true \\

  --runtime-config='api/all=true' \\

  --service-account-key-file=/var/lib/kubernetes/service-account.pem \\

  --service-cluster-ip-range=10.32.0.0/24 \\

  --service-node-port-range=30000-32767 \\

  --tls-cert-file=/var/lib/kubernetes/kubernetes.pem \\

  --tls-private-key-file=/var/lib/kubernetes/kubernetes-key.pem \\

  --v=2

Restart=on-failure

RestartSec=5

[Install]

WantedBy=multi-user.target

## Configure the Kubernetes Controller Manager

- Move the kube-controller-manager kubeconfig into place:

  sudo cp kube-controller-manager.kubeconfig /var/lib/kubernetes/

Create the kube-controller-manager.service systemd unit file: 

vim /etc/systemd/system/kube-controller-manager.service

[Unit]

Description=Kubernetes Controller Manager

Documentation=https://github.com/kubernetes/kubernetes

[Service]

ExecStart=/usr/local/bin/kube-controller-manager \\

  --bind-address=0.0.0.0 \\

  --cluster-cidr=10.200.0.0/16 \\

  --cluster-name=kubernetes \\

  --cluster-signing-cert-file=/var/lib/kubernetes/ca.pem \\

  --cluster-signing-key-file=/var/lib/kubernetes/ca-key.pem \\

  --kubeconfig=/var/lib/kubernetes/kube-controller-manager.kubeconfig \\

  --leader-elect=true \\

  --root-ca-file=/var/lib/kubernetes/ca.pem \\

  --service-account-private-key-file=/var/lib/kubernetes/service-account-key.pem \\

  --service-cluster-ip-range=10.32.0.0/24 \\

  --use-service-account-credentials=true \\

  --v=2

Restart=on-failure

RestartSec=5

[Install]

WantedBy=multi-user.targ

## Configure the Kubernetes Scheduler

- Move the kube-scheduler kubeconfig into place:

  sudo cp kube-scheduler.kubeconfig /var/lib/kubernetes/

- Create the kube-scheduler.yaml configuration file:

vim /etc/kubernetes/config/kube-scheduler.yaml

apiVersion: kubescheduler.config.k8s.io/v1alpha1

kind: KubeSchedulerConfiguration

clientConnection:

  kubeconfig: "/var/lib/kubernetes/kube-scheduler.kubeconfig"

leaderElection:

  leaderElect: true

- Create the kube-scheduler.service systemd unit file:

vim /etc/systemd/system/kube-scheduler.service

[Unit]

Description=Kubernetes Scheduler

Documentation=https://github.com/kubernetes/kubernetes

[Service]

ExecStart=/usr/local/bin/kube-scheduler \\

  --config=/etc/kubernetes/config/kube-scheduler.yaml \\

  --v=2

Restart=on-failure

RestartSec=5

[Install]

WantedBy=multi-user.target

## Start the Controller Services

  sudo systemctl daemon-reload
  
  sudo systemctl enable kube-apiserver kube-controller-manager kube-scheduler
  
  sudo systemctl start kube-apiserver kube-controller-manager kube-scheduler