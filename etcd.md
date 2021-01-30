#  etcd 
etcd is the backend for service discovery and stores cluster state and configuration.
etcd is a strongly consistent, distributed key-value store that provides a reliable way to store data that needs to be accessed by a distributed system or cluster of machines.

# How is etcd used in kubernetes ?
Kubernetes used etcd to store all of its internal data about the cluster state.
 This data needs to be store, but it also needs to be reliably synchronized across all controller nodes in the cluster. etcd fulfils that purpose.

# How to creating etcd clusers ?
```* Download etcd binaries ```
```
wget -q --show-progress --https-only --timestamping \
  "https://github.com/etcd-io/etcd/releases/download/v3.4.10/etcd-v3.4.10-linux-amd64.tar.gz"
```

## Extract and install the etcd server and the etcdctl command line utility.
```
  tar -xvf etcd-v3.4.10-linux-amd64.tar.gz
  sudo mv etcd-v3.4.10-linux-amd64/etcd* /usr/local/bin/
```
## Configure the etcd server
```  
  sudo mkdir -p /etc/etcd /var/lib/etcd
  sudo chmod 700 /var/lib/etcd
  sudo cp ca.pem kubernetes-key.pem kubernetes.pem /etc/etcd/
```
## Set unique name within an etcd cluster.
```
  ETCD_NAME=master1.mylap.in
       (OR)
  ETCD_NAME=master2.mylap.in
```
## Set internal ip
```  
INTERNAL_IP=$(hostname -I | awk '{print $1}')
Master1=192.168.5.146
Master2=192.168.5.55
```
## Create etcd service 
```* Create the etcd.service systemd unit file```
```
cat <<EOF | sudo tee /etc/systemd/system/etcd.service
[Unit]
Description=etcd
Documentation=https://github.com/coreos

[Service]
Type=notify
ExecStart=/usr/local/bin/etcd \\
  --name ${ETCD_NAME} \\
  --cert-file=/etc/etcd/kubernetes.pem \\
  --key-file=/etc/etcd/kubernetes-key.pem \\
  --peer-cert-file=/etc/etcd/kubernetes.pem \\
  --peer-key-file=/etc/etcd/kubernetes-key.pem \\
  --trusted-ca-file=/etc/etcd/ca.pem \\
  --peer-trusted-ca-file=/etc/etcd/ca.pem \\
  --peer-client-cert-auth \\
  --client-cert-auth \\
  --initial-advertise-peer-urls https://${INTERNAL_IP}:2380 \\
  --listen-peer-urls https://${INTERNAL_IP}:2380 \\
  --listen-client-urls https://${INTERNAL_IP}:2379,https://127.0.0.1:2379 \\
  --advertise-client-urls https://${INTERNAL_IP}:2379 \\
  --initial-cluster-token etcd-cluster-0 \\
  --initial-cluster controller-0=https://192.168.5.146:2380,controller-1=https://192.168.5.55:2380 \\
  --initial-cluster-state new \\
  --data-dir=/var/lib/etcd
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

```

### Start The etcd Services 
```
systemctl daemon-reload
systemctl enable etcd
systemctl start etcd
systemctl status etcd
```
### Verification
```
sudo ETCDCTL_API=3 etcdctl member list \
  --endpoints=https://127.0.0.1:2379 \
  --cacert=/etc/etcd/ca.pem \
  --cert=/etc/etcd/kubernetes.pem \
  --key=/etc/etcd/kubernetes-key.pem
```
### Results
```
96373554a7ef5f13, started, master1.mylap.in, https://192.168.5.146:2380, https://192.168.5.146:2379, false
dc1dbf50a682260a, started, master2.mylap.in, https://192.168.5.55:2380, https://192.168.5.55:2379, false
```