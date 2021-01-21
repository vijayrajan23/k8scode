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