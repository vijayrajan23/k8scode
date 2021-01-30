### Kubernetes worker nodes.
Kubernetes worker nodes are responsible for the actual work of running container applications managed by kubernetes.
The Kubernetes nodes has the services necessary to run application containers and be managed from the master system.

## kubernetes worker node components
```* kubelet ``` kubelet is a kubernetes agent. It controls each worker node, providing the API that are used by the control plane to manage nodes and pods, and inertacts with the container runtime to manage containers.
```* Kube-proxy ``` Manages iptabales rules on the node to provide virtual network access to pods.
```* Container runtime ``` 
## Provisioning a Kubernetes Worker Node.
```
  sudo apt-get update
  sudo apt-get -y install socat conntrack ipset
```
## Disable Swap
```* Verify if swap is enabled ```

``` 
sudo swapon --show
 ```

```*  If swap is enabled run the following command to disable swap immediately ```

``` 
sudo swapoff -a 
```

## Download and Install Worker Binaries.
```wget -q --show-progress --https-only --timestamping \
  https://github.com/kubernetes-sigs/cri-tools/releases/download/v1.20.0/crictl-v1.20.0-linux-amd64.tar.gz \
  https://github.com/opencontainers/runc/releases/download/v1.0.0-rc91/runc.amd64 \
  https://github.com/containernetworking/plugins/releases/download/v0.8.6/cni-plugins-linux-amd64-v0.8.6.tgz \
  https://github.com/containerd/containerd/releases/download/v1.3.6/containerd-1.3.6-linux-amd64.tar.gz \
  https://storage.googleapis.com/kubernetes-release/release/v1.20.0/bin/linux/amd64/kubectl \
  https://storage.googleapis.com/kubernetes-release/release/v1.20.0/bin/linux/amd64/kube-proxy \
  https://storage.googleapis.com/kubernetes-release/release/v1.20.0/bin/linux/amd64/kubelet
```
```* Create the installation directories ```
```
sudo mkdir -p \
   /etc/cni/net.d \
   /opt/cni/bin \
   /var/lib/kubelet \
   /var/lib/kube-proxy \
   /var/lib/kubernetes \
   /var/run/kubernetes
```
```* Install the worker binaries ```
```
  mkdir containerd
  tar -xvf crictl-v1.20.0-linux-amd64.tar.gz
  tar -xvf containerd-1.3.6-linux-amd64.tar.gz -C containerd
  sudo tar -xvf cni-plugins-linux-amd64-v0.8.6.tgz -C /opt/cni/bin/
  sudo mv runc.amd64 runc
  chmod +x crictl kubectl kube-proxy kubelet runc 
  sudo mv crictl kubectl kube-proxy kubelet runc /usr/local/bin/
  sudo mv containerd/bin/* /bin/
```
  ## Configure containerd
  Create the containerd configuration file:
```
sudo mkdir -p /etc/containerd/
```
```
vim /etc/containerd/config.toml
[plugins]
  [plugins.cri.containerd]
    snapshotter = "overlayfs"
    [plugins.cri.containerd.default_runtime]
      runtime_type = "io.containerd.runtime.v1.linux"
      runtime_engine = "/usr/local/bin/runc"
      runtime_root = ""
```
Create the containerd.service systemd unit file:
```
vim /etc/systemd/system/containerd.service

[Unit]
Description=containerd container runtime
Documentation=https://containerd.io
After=network.target

[Service]
ExecStartPre=/sbin/modprobe overlay
ExecStart=/bin/containerd
Restart=always
RestartSec=5
Delegate=yes
KillMode=process
OOMScoreAdjust=-999
LimitNOFILE=1048576
LimitNPROC=infinity
LimitCORE=infinity

[Install]
WantedBy=multi-user.target
```
## Configure the Kubelet
```
  sudo mv ${HOSTNAME}-key.pem ${HOSTNAME}.pem /var/lib/kubelet/
  sudo mv ${HOSTNAME}.kubeconfig /var/lib/kubelet/kubeconfig
  sudo mv ca.pem /var/lib/kubernetes/
```
```* Create the kubelet-config.yaml configuration file ```
```
vim  /var/lib/kubelet/kubelet-config.yaml

kind: KubeletConfiguration
apiVersion: kubelet.config.k8s.io/v1beta1
authentication:
  anonymous:
    enabled: false
  webhook:
    enabled: true
  x509:
    clientCAFile: "/var/lib/kubernetes/ca.pem"
authorization:
  mode: Webhook
clusterDomain: "cluster.local"
clusterDNS:
  - "10.32.0.10"
podCIDR: "${POD_CIDR}"
resolvConf: "/run/systemd/resolve/resolv.conf"
runtimeRequestTimeout: "15m"
tlsCertFile: "/var/lib/kubelet/${HOSTNAME}.pem"
tlsPrivateKeyFile: "/var/lib/kubelet/${HOSTNAME}-key.pem"
```
```* Create the kubelet.service systemd unit file ```
```
vim  /etc/systemd/system/kubelet.service

[Unit]
Description=Kubernetes Kubelet
Documentation=https://github.com/kubernetes/kubernetes
After=containerd.service
Requires=containerd.service

[Service]
ExecStart=/usr/local/bin/kubelet \\
  --config=/var/lib/kubelet/kubelet-config.yaml \\
  --container-runtime=remote \\
  --container-runtime-endpoint=unix:///var/run/containerd/containerd.sock \\
  --image-pull-progress-deadline=2m \\
  --kubeconfig=/var/lib/kubelet/kubeconfig \\
  --network-plugin=cni \\
  --register-node=true \\
  --v=2
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
```
## Configure the Kubernetes Proxy
```
sudo mv kube-proxy.kubeconfig /var/lib/kube-proxy/kubeconfig
```
```* Create the kube-proxy-config.yaml configuration file ```
```
vim  /var/lib/kube-proxy/kube-proxy-config.yaml

kind: KubeProxyConfiguration
apiVersion: kubeproxy.config.k8s.io/v1alpha1
clientConnection:
  kubeconfig: "/var/lib/kube-proxy/kubeconfig"
mode: "iptables"
clusterCIDR: "10.200.0.0/16"
```

```* Create the kube-proxy.service systemd unit file ```
```
vim /etc/systemd/system/kube-proxy.service

[Unit]
Description=Kubernetes Kube Proxy
Documentation=https://github.com/kubernetes/kubernetes

[Service]
ExecStart=/usr/local/bin/kube-proxy \\
  --config=/var/lib/kube-proxy/kube-proxy-config.yaml
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
```
## Start the Worker Services
```
  sudo systemctl daemon-reload
  sudo systemctl enable containerd kubelet kube-proxy
  sudo systemctl start containerd kubelet kube-proxy
```
# Verification
```
kubectl get nodes 
```
```
NAME               STATUS   ROLES    AGE   VERSION
worker1.mylap.in   Ready    <none>   21h   v1.20.0
```





  