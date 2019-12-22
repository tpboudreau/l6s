

# L6S

A flexible Helm 3 chart and supporting resources for deploying [LibreNMS](https://www.librenms.org/ "LibreNMS") on Kubernetes.  If you've got (1) a Kubernetes cluster, (2) kubectl [installed and configured](https://kubernetes.io/docs/tasks/tools/install-kubectl/ "Install and Set Up kubectl") to access your cluster, and (3) helm 3.0 [installed](https://helm.sh/docs/intro/install/ "Installing Helm"), then you're ready to deploy LibreNMS.

> Most of this document assumes that you have the [Nginx Ingress controller](https://kubernetes.github.io/ingress-nginx/) running in your cluster (and scanning the installation namespace).  See xxx if you are deploying to a cluster without an ingress controller.

All installations require a few common chart variables to be set at deployment time.  The easiest way to do this is to create a YAML file, called (say) `values.yaml`, containing these values.  Its contents should look something like:

    Application:
      serviceType: ingress
      ingressHost: "librenms.example.com"
    credentials:
      application:
        administrativeUser: "admin"
        administrativePassword: "adminPassword"
        administrativeEmail: "admin@example.org"
      mysql:
        rootPassword: "mysqlRootPassword"
        user: "librenms"
        password: "userPassword"
      redis:
        password: "redisPassword"

Setting Application.serviceType key to "ingress" overrides the default service type of "ClusterIP" for the WebUI and API.  The Application.ingressHost key should be set to a hostname that will resolve to the IP address of your ingress controller's load balancer; the ingress resource installed for LibreNMS will capture all traffic directed to the given hostname.  

The installation will comprise four supporting services: a MySQL instance, an RRDCached server, a memcached server, and a Redis instance.  The credentials.mysql.{rootPassword, user, password} and credentials.redis.password keys are used to specify the credentials that should be created for their respective services during installation.  Be sure to change the passwords from the example given above to confidential, strong passwords (See yyy below for information about the credential.mysql.* keys if you choose to manage your MySQL instance outside the Kubernetes cluster.)

The credentials.application.* keys are used to specify information about the initial LibreNMS application user that will be created during installation.  This is the user and password you will use to log into the application's WebUI.  Again, be sure to change the example values to suitable values.
### Evaluation Installation
To deploy a simple, temporary test installation, just run:

    kubectl create namespace librenms
    helm install librenms \
      --generate-name \
      --values values.yaml \
      --namespace librenms \
      --set credentials.application.key=$(docker run --rm tpboudreau/librenms-generate-key) \
      --set librenmsServices.mysql.storage.type=temporary \
      --set librenmsServices.rrdcached.storage.type=temporary \
      --set librenmsServices.redis.storage.type=temporary

This invocation will instantiate the four supporting data services backed by temporary volumes.  This means that the contents of these databases will be destroyed after the pods containing the database services are deleted, so the 'temporary' storage type is suitable only for short-lived evaluation installations or other non-production testing.
You may choose any name for the namespace into which the application is deployed (or omit the namespace entirely and deploy in the default namespace, though that is not recommended).  The credentials.application.key key is used to set the APP_KEY environment variable required by the LibreNMS PHP component; the librenms-generate-key convenience Docker image is provided to ensure that this key is well-formed.
> Any values provided with the helm command line --set option can alternatively be provided in a values file.

To remove the application from the cluster, find the name generated for the deployment with the list command, then uninstall the chart and delete the namespace:

    helm list -n librenms
    helm uninstall -n librenms $GENERATED_NAME
    kubectl delete namespace librenms

### Typical Installation
##### Dynamic Volumes
Production deployments will obviously require persistent storage for the database services.  To dynamically allocate persistent volumes during installation, create a target namespace, then invoke helm like:

    kubectl create namespace librenms
    helm install librenms \
      --generate-name \
      --values values.yaml \
      --namespace librenms \
      --set credentials.application.key=$(docker run --rm tpboudreau/librenms-generate-key) \
      --set librenmsServices.mysql.readinessDelay=60 \
      --set librenmsServices.mysql.storage.type=dynamic \
      --set librenmsServices.mysql.storage.class=ssd \
      --set librenmsServices.mysql.storage.size=100Gi \
      --set librenmsServices.rrdcached.storage.type=dynamic \
      --set librenmsServices.rrdcached.storage.class=standard \
      --set librenmsServices.rrdcached.storage.size=500Gi \
      --set librenmsServices.redis.storage.type=dynamic \
      --set librenmsServices.redis.storage.class=standard \
      --set librenmsServices.redis.storage.size=50Gi

For each service backed by disk, (1) set the storage.type key to 'dynamic' to indicate that Kubernetes should dynamically allocate persistent volumes (and corresponding persistent volume claims); (2) set the storage.class key to an appropriate storageClass available in your Kubernetes cluster; and (3) set the storage.size key to a value commensurate with the size of the network being monitored.
By default, the job created to prepare the MySQL instance for use by LibreNMS is delayed for 15 seconds, to allow the volumes to be allocated and mounted, and the database to initialize itself and become ready for connections.  This delay can be extended if necessary by setting the librenmsServices.mysql.readinessDelay key to a larger value (in seconds), as shown above.
##### Static Volumes
Alternatively, persistent volumes for the data services may be created and bound to persistent volume claims in advance.  If you choose this option, you take on the responsibility of making sure that the disks are appropriately sized, correctly formatted and contain the expected subdirectories (properly owned and/or permissioned).  (The actions required to do this differ for each system and cloud provider and are beyond the scope of these instructions.)  The following table shows the expected subdirectories on each volume for each service:

| Service | Subdirectories | Ownership |
| ------- | -------------- | --------- |
| MySQL | /configuration | 999:999 |
| | /database | 999:999 |
| | /initialization | 999:999 |
| RRDCached | /data | 1010:1010 |
| | /journal | 1010:1010 |
| Redis | /data | 999:1000 |

After creating, formatting, and configuring the disk(s), you must create a Kubernetes persistent volume resource for each disk and bind a corresponding persistent volume claim resource to each persistent volume.  Again, the particulars on creating these resources vary slightly for each Kubernetes cluster, but assuming, for example, a GCE persistent disk named 'l6s-mysql' formatted with the ext4 filesystem) the required resources for a static MySQL volume will resemble:

    kind: PersistentVolume
    apiVersion: v1
    metadata:
      name: mysql-volume
      labels:
        forProvider: mysql
    spec:
      capacity:
        storage: 100Gi
      accessModes:
      - ReadWriteOnce
      volumeMode: Filesystem
      gcePersistentDisk:
        fsType: ext4
        pdName: l6s-mysql
    ---
    apiVersion: v1
    kind: PersistentVolumeClaim
    metadata:
      namespace: librenms
      name: mysql-volume
    spec:
      accessModes:
      - ReadWriteOnce
      storageClassName: ""
      volumeMode: Filesystem
      resources:
        requests:
      storage: 100Gi
      selector:
        matchLabels:
          forProvider: mysql

Be sure to create and place the persistent volume claim(s) in the namespace in which the application will be deployed.  After creating the claim(s), invoke helm like:

    
    helm install librenms \
      --generate-name \
      --values values.yaml \
      --namespace librenms \
      --set credentials.application.key=$(docker run --rm tpboudreau/librenms-generate-key) \
      --set librenmsServices.mysql.storage.type=static \
      --set librenmsServices.mysql.storage.claimName=mysql-volume \
      --set librenmsServices.rrdcached.storage.type=static \
      --set librenmsServices.rrdcached.storage.claimName=rrdcached-volume \
      --set librenmsServices.redis.storage.type=static \
      --set librenmsServices.redis.storage.claimName=redis-volume

Here, the persistent storage for each service is marked 'static' (that is, pre-allocated and configured) and the storage.claimName keys provide the name of the persistent volume claim(s) manually created earlier.


















# l6s

WIP LibreNMS k8s+helm

Options for database instances (mysql and rrdcached):

- cluster (typical clusterip service created; pods are created to run mysql and rrdcached) [default]
  - with ephemeral storage (for tire-kicking)
  - with pre-provisioned persistent storage (for the OG)
  - with dynamically provisioned persistent storage [default]

- external (non-selecting clusterip service created + endpoints routing to provided address:port) [GR]

Options for application service (for webUI/API):

- clusterip only (external DNS routing to cluster) [default]
- loadbalancer (http only (maybe later https) + nginx whitelist acl; useful for cloud k8s installations)
- ingress (with NodePoint cluster service; ingress load balancer handles SSL termination) [GR]

Options for database services (for dispatchers):

- clusterip(s) only (valid if no remote pollers/dispatchers, or if external DNS routing per service) [default] [GR]
- one loadbalancer per service (dangerous without ACLs anywhere in route; some cloud providers support source IP restrictions)
- one load balancer for all services (requires lightweight static gateway proxy to route and enforce ACLs -- proxy protocol would be ideal, but requires controllers in pods)
- ingress(es) (provided TCP routing is supported to route and enforce ACLs -- proxy protocol would be ideal, but requires controllers in pods)

Options for credential rotation:

- never
- on-demand [default]
- periodic

Options for application update:

- never
- on-demand [default]
- periodic

------------------------------------

For temporary databases:

kubectl create namespace librenms-temporary

helm install \
  --generate-name \
  --values values.yaml \
  --namespace librenms-temporary \
  --set librenmsServices.mysql.storage.type=temporary \
  --set librenmsServices.rrdcached.storage.type=temporary \
  --set librenmsServices.redis.storage.type=temporary \
  librenms
   
helm list --namespace librenms-temporary

...

helm uninstall librenms-$RELEASE_ID --namespace librenms-temporary

kubectl delete namespace librenms-temporary

----------------------------------------------------------------------------------------------------------------

For databases backed by pre-configured persistent volume claims (the default):

kubectl create namespace librenms

helm install \
  --generate-name \
  --values values.yaml \
  --namespace librenms \
  --set librenmsServices.mysql.storage.claimName=$MYSQL_PVC_NAME \
  --set librenmsServices.rrdcached.storage.claimName=$RRDCACHED_PVC_NAME \
  --set librenmsServices.redis.storage.claimName=$REDIS_PVC_NAME \
  librenms

helm list --namespace librenms

...

helm uninstall $GENERATED_NAME --namespace librenms

kubectl delete namespace librenms

----------------------------------------------------------------------------------------------------------------

For databases running outside the Kubernetes cluster ...

kubectl create namespace librenms

helm install \
  --generate-name \
  --values values.yaml \
  --namespace librenms \
  --set librenmsServices.mysql.external.enabled=true,librenmsServices.mysql.external.address=$MYSQL_IP_ADDRESS,librenmsServices.mysql.external.port=$MYSQL_PORT \
  --set librenmsServices.rrdcached.external.enabled=true,librenmsServices.rrdcached.external.address=$RRDCACHED_IP_ADDRESS,librenmsServices.rrdcached.external.port=$RRDCACHED_PORT \
  --dry-run \
  librenms

helm list --namespace librenms

...

helm uninstall $GENERATED_NAME --namespace librenms

kubectl delete namespace librenms

----------------------------------------------------------------------------------------------------------------

For running the application in a Kubernetes cluster that forbids setuid / set-cap binaries ...

kubectl create namespace librenms

helm install \
  --generate-name \
  --values values.yaml \
  --namespace librenms \
  --set snmpPing.enabled=true \
  librenms

helm list --namespace librenms

...

helm uninstall $GENERATED_NAME --namespace librenms

kubectl delete namespace librenms

