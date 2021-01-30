# kubernetes control plane
 The kubernetes control plane is a set service that control the kubernetes cluster.
 Control plane components make global decisions about the cluster (ex; Scheduling ) and detect respond to cluster events(ex; starting up a new pod when a replication controllers replicas field is unspecified.

## Kubernetes Control Plane components
```* Kube-APIserver ``` This allows users to interact with the cluster.
```* etcd ``` Kubernetes cluster datastore.
```* kube-scheduler ``` Schedules pods on available worker nodes.
```* kube-controller-manager ``` Runs a series of controllers that provide a wide range funcation.
```* colud-controller-manager ``` Handles interaction with underlying cloud providers.

## Installing kubernetes control plane binaries

```* Kube-APIserver ```
```* Kube-Scheduler ```
```* Kubectl ```
```* Kube-controller-manager ```
```*** Thouse service binaries download install masternode. ```

## Create the Kubernetes configuration directory:
``` sudo mkdir -p /etc/kubernetes/config ```
## Download Links and commands.
```
wget -q --show-progress --https-only --timestamping \
  "https://storage.googleapis.com/kubernetes-release/release/v1.20.0/bin/linux/amd64/kube-apiserver" \
  "https://storage.googleapis.com/kubernetes-release/release/v1.20.0/bin/linux/amd64/kube-controller-manager" \
  "https://storage.googleapis.com/kubernetes-release/release/v1.20.0/bin/linux/amd64/kube-scheduler" \
  "https://storage.googleapis.com/kubernetes-release/release/v1.20.0/bin/linux/amd64/kubectl"
```
## Install the kubernets binaries.
```
 chmod +x kube-apiserver kube-controller-manager kube-scheduler kubectl
 sudo mv kube-apiserver kube-controller-manager kube-scheduler kubectl /usr/local/bin/
```
## Configure the kube-apiserver
Create directory for openssl certificate file.
```  sudo mkdir -p /var/lib/kubernetes/ ```
 Copy Thouse certifacte file.
``` 
 sudo mv ca.pem ca-key.pem kubernetes-key.pem kubernetes.pem \
    service-account-key.pem service-account.pem \
    encryption-config.yaml /var/lib/kubernetes/
```
## The instance internal IP address will be used to advertise the API Server to members of the cluster. Retrieve the internal IP address for the current compute instance
```
master1=192.168.5.146
master2=192.168.5.55
INTERNAL_IP= master1 ro master2
```
## Create the kube-apiserver.service systemd unit file:
```
cat <<EOF | sudo tee /etc/systemd/system/kube-apiserver.service
[Unit]
Description=Kubernetes API Server
Documentation=https://github.com/kubernetes/kubernetes

[Service]
ExecStart=/usr/local/bin/kube-apiserver \\
  --advertise-address=${INTERNAL_IP} \\
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
  --etcd-servers=https://${master1}:2379,https://${master2}:2379 \\
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
EOF

```
## Configure the Kubernetes Controller Manager
Move the kube-controller-manager kubeconfig into place:
```
  sudo cp kube-controller-manager.kubeconfig /var/lib/kubernetes/
```
Create the kube-controller-manager.service systemd unit file: 
```
cat <<EOF | sudo tee /etc/systemd/system/kube-controller-manager.service
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
  --service-account-signing-key-file=/var/lib/kubernetes/service-account-key.pem \\  
  --service-account-private-key-file=/var/lib/kubernetes/service-account.pem \\
  --service-account-issuer=api \\
  --service-cluster-ip-range=10.32.0.0/24 \\
  --use-service-account-credentials=true \\
  --v=2
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF
```
## Configure the Kubernetes Scheduler
 Move the kube-scheduler kubeconfig into place:
```
sudo cp kube-scheduler.kubeconfig /var/lib/kubernetes/
```
Create the kube-scheduler.yaml configuration file:
```
cat <<EOF | sudo tee /etc/kubernetes/config/kube-scheduler.yaml
apiVersion: kubescheduler.config.k8s.io/v1beta1
kind: KubeSchedulerConfiguration
clientConnection:
  kubeconfig: "/var/lib/kubernetes/kube-scheduler.kubeconfig"
leaderElection:
  leaderElect: true
EOF
```
Create the kube-scheduler.service systemd unit file:
```
cat <<EOF | sudo tee /etc/systemd/system/kube-scheduler.service
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
EOF

```
## Start the Controller Services
```
  sudo systemctl daemon-reload
  sudo systemctl enable kube-apiserver kube-controller-manager kube-scheduler
  sudo systemctl start kube-apiserver kube-controller-manager kube-scheduler
```
## Enable HTTP Health Checks
Install a basic web server to handle HTTP health checks:
```
sudo apt-get update
sudo apt-get install -y nginx
```
```
cat > kubernetes.default.svc.cluster.local <<EOF
server {
  listen      80;
  server_name kubernetes.default.svc.cluster.local;
  location /healthz {
     proxy_pass                    https://127.0.0.1:6443/healthz;
     proxy_ssl_trusted_certificate /var/lib/kubernetes/ca.pem;
  }
}
EOF
```
```
sudo mv kubernetes.default.svc.cluster.local \
/etc/nginx/sites-available/kubernetes.default.svc.cluster.local

sudo ln -s /etc/nginx/sites-available/kubernetes.default.svc.cluster.local /etc/nginx/sites-enabled/
```
```
sudo systemctl restart nginx
sudo systemctl enable nginx
```
## Verification
```
kubectl get componentstatuses --kubeconfig admin.kubeconfig
```
## Results
```
Warning: v1 ComponentStatus is deprecated in v1.19+
NAME                 STATUS    MESSAGE             ERROR
etcd-1               Healthy   {"health":"true"}   
etcd-0               Healthy   {"health":"true"}   
scheduler            Healthy   ok                  
controller-manager   Healthy   ok  
```
## Test the nginx HTTP health check proxy:
```
curl -H "Host: kubernetes.default.svc.cluster.local" -i http://127.0.0.1/healthz
HTTP/1.1 200 OK
Server: nginx/1.14.0 (Ubuntu)
Date: Sat, 30 Jan 2021 15:23:23 GMT
Content-Type: text/plain; charset=utf-8
Content-Length: 2
Connection: keep-alive
Cache-Control: no-cache, private
X-Content-Type-Options: nosniff
X-Kubernetes-Pf-Flowschema-Uid: 8b2400e9-b010-4148-8c50-96af128d362b
X-Kubernetes-Pf-Prioritylevel-Uid: e8101f93-0f8a-4d8e-816d-551b2d30c03a

ok
```
## RBAC for Kubelet Authorization

```* In this section you will configure RBAC permissions to allow the Kubernetes API Server to access the Kubelet API on each worker node. Access to the Kubelet API is required for retrieving metrics, logs, and executing commands in pods. ```

```* The commands in this section will effect the entire cluster and only need to be run once from one of the controller nodes. ```

```* Create the system:kube-apiserver-to-kubelet ClusterRole with permissions to access the Kubelet API and perform most common tasks associated with managing pods. ```
```
cat <<EOF | kubectl apply --kubeconfig admin.kubeconfig -f -
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRole
metadata:
  annotations:
    rbac.authorization.kubernetes.io/autoupdate: "true"
  labels:
    kubernetes.io/bootstrapping: rbac-defaults
  name: system:kube-apiserver-to-kubelet
rules:
  - apiGroups:
      - ""
    resources:
      - nodes/proxy
      - nodes/stats
      - nodes/log
      - nodes/spec
      - nodes/metrics
    verbs:
      - "*"
EOF
```
```*The Kubernetes API Server authenticates to the Kubelet as the kubernetes user using the client certificate as defined by the --kubelet-client-certificate flag. ```

```* Bind the system:kube-apiserver-to-kubelet ClusterRole to the kubernetes user ```
```
cat <<EOF | kubectl apply --kubeconfig admin.kubeconfig -f -
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  name: system:kube-apiserver
  namespace: ""
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: system:kube-apiserver-to-kubelet
subjects:
  - apiGroup: rbac.authorization.k8s.io
    kind: User
    name: kubernetes
EOF
```
## The Kubernetes Frontend Load Balancer:
Configure the loadbalancer nginx or haproxy.
```
* install nginx and haporxy
```
Configure nginx and haporxy
```
vim /etc/nginx/tcpconf.d/kubernetes.conf
stream {
    upstream kubernetes {
        server 192.168.5.146:6443;
        server 192.168.5.55:6443;
    }
    server {
        listen 6443;
        listen 443;
        proxy_pass kubernetes;
    }
}

```
# Results 
```
curl -k https://localhost:6443/version
```
```
{
  "major": "1",
  "minor": "20",
  "gitVersion": "v1.20.0",
  "gitCommit": "af46c47ce925f4c4ad5cc8d1fca46c7b77d13b38",
  "gitTreeState": "clean",
  "buildDate": "2020-12-08T17:51:19Z",
  "goVersion": "go1.15.5",
  "compiler": "gc",
  "platform": "linux/amd64"
}
```