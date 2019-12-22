

# L6S

A flexible Helm 3 chart and supporting resources for deploying [LibreNMS](https://www.librenms.org/ "LibreNMS") on Kubernetes.  If you've got (1) a Kubernetes cluster, (2) kubectl [installed and configured](https://kubernetes.io/docs/tasks/tools/install-kubectl/ "Install and Set Up kubectl") to access your cluster, and (3) helm 3.0 [installed](https://helm.sh/docs/intro/install/ "Installing Helm"), then you're ready to deploy LibreNMS.

> Most of this document assumes that you have the [Nginx Ingress controller](https://kubernetes.github.io/ingress-nginx/) running in your cluster (and scanning the installation namespace).  See xxx if you are deploying to a cluster without an ingress controller.

All types of installation require a few common chart variables to be set at deployment time.  The easiest way to do this is to create a YAML file, called (say) `values.yaml`, containing these values.  Its contents should look something like:

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

Setting Application.serviceType key to 'ingress' overrides the default service type of 'ClusterIP' for the WebUI and API.  The Application.ingressHost key should be set to a hostname that will resolve to the IP address of your ingress controller's load balancer; the ingress resource installed for LibreNMS will capture all traffic directed to the given hostname.  

An installation comprises four supporting services: a MySQL instance, an RRDCached server, a memcached server, and a Redis instance.  The credentials.mysql.{rootPassword, user, password} and credentials.redis.password keys are used to specify the credentials that you wish to be created for their respective services during installation.  Be sure to change the passwords from the examples given to strong and confidential passwords (See yyy below for information about the credential.mysql.* keys if you choose to manage your MySQL instance outside the Kubernetes cluster.)

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

This invocation will instantiate the supporting data services backed by temporary volumes.  This means that the contents of these databases will be lost after the pods containing the corresponding database services are deleted, so the temporary storage type is suitable only for short-lived evaluation installations or other non-production testing.
You may choose any name for the namespace into which the application is deployed (or omit the namespace entirely and deploy in the default namespace, though that is not recommended).  The credentials.application.key key is used to set the APP_KEY environment variable required by the LibreNMS PHP components; the librenms-generate-key convenience Docker image is provided to ensure that this key is well-formed.
> Any values provided with the helm command line --set option can alternatively be provided in a values file.

##### Cleanup

To remove the application from the cluster, find the name generated for the deployment with the list command, then uninstall the chart and delete the namespace:

    helm list -n librenms
    helm uninstall -n librenms $GENERATED_NAME
    kubectl delete namespace librenms

### Typical Installation
##### Dynamic Volumes
Production deployments will obviously require persistent storage for the database services.  To dynamically allocate persistent volumes during installation, first create a target namespace, then invoke helm like:

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
Alternatively, persistent volumes for the data services may be created and bound to persistent volume claims in advance.  If you choose this option, you take on the responsibility of making sure that the disks are appropriately sized, correctly formatted and contain the subdirectories (properly owned and/or permissioned) that are expected by the services.  (The actions required to do this differ for each system and cloud provider and are beyond the scope of these instructions.)  The following table shows the expected subdirectories on each volume for each service:

| Service | Subdirectories | Ownership (uid:gid) |
| ------- | -------------- | ------------------- |
| MySQL | /configuration | 999:999 |
| | /database | 999:999 |
| | /initialization | 999:999 |
| RRDCached | /data | 1010:1010 |
| | /journal | 1010:1010 |
| Redis | /data | 999:1000 |

As an alternative to changing the ownership, you can set he permission to 0x0777 (read-write-search for all) for each directory.

After creating, formatting, and configuring the disk(s), you must create a Kubernetes persistent volume resource for each disk and bind a corresponding persistent volume claim resource to each persistent volume.  Again, the particulars on creating these resources vary slightly for each Kubernetes cluster, but assuming, for example, a GCE persistent disk named 'l6s-mysql' formatted with the ext4 filesystem, the required resources for a static MySQL volume will resemble:

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

Be sure to first create the namespace in which the application will be deployed and place the persistent volume claim(s) in that namespace.  After creating the claim(s), invoke helm like:

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

### Non-Cluster Databases

If you prefer, for performance or other operational reasons, you may run either the MySQL or RRDCached service outside the installation cluster.  If you choose this option, you take full responsibility for creating and managing the database instance or service.

##### MySQL

You may configure your MySQL instance as appropriate for your needs and environment, however, LibreNMS expects a dedicated database schema (conventionally named 'librenms') and a user with full privileges on that database.  At least the following SQL statements (run by a privileged user) are therefore recommended:

    CREATE DATABASE librenms;
    ALTER DATABASE librenms CHARACTER SET utf8 COLLATE utf8_unicode_ci;
    CREATE USER 'librenms'@'%' IDENTIFIED BY 'userPassword';
    GRANT ALL PRIVILEGES ON librenms.* TO 'librenms'@'%';
    FLUSH PRIVILEGES;

Make sure that the librenms user password is appropriately secure and confidential.

> Note that for an ordinary, in-cluster MySQL database, the MySQL credentials passed to helm at installation are those which ***will be created during deployment***.  However, when running your MySQL instance outside the installation cluster, these credentials are those which you ***have already created in your MySQL instance*** and that LibreNMS should use to connect.  Also, for non-cluster MySQL databases, you need not provide the root password for your instance.

##### RRDCached

You may configure and run the rrdcached server as appropriate for your environment.  Be sure to permit recursive access to the base data directory (with the '-R' command line option) as LibreNMS typically creates one subdirectory per device.

##### Installation

After instantiating your non-cluster database services, invoke helm like:

    kubectl create namespace librenms
    helm install librenms \
      --generate-name \
      --values values.yaml \
      --namespace librenms \
      --set credentials.application.key=$(docker run --rm tpboudreau/librenms-generate-key) \
      --set librenmsServices.mysql.external.enabled=true \
      --set librenmsServices.mysql.external.address=m.m.m.m \
      --set librenmsServices.mysql.external.port=3306 \
      --set librenmsServices.rrdcached.external.enabled=true \
      --set librenmsServices.rrdcached.external.address=r.r.r.r \
      --set librenmsServices.rrdcached.external.port=42217

Setting the {mysql, rrdcached}.external.enabled key to 'true' indicates to helm that it should not create pods to run these services during installation.  Instead, the cluster service resources created during installation will direct traffic to the IPv4 external.address and external.port values provided.  The external.port key is optional: it defaults to 3306 for MySQL and to 42217 for RRDCached.  

### Non-escalating Executables

LibreNMS ordinarily uses fping (or ping) to test via ICMP whether monitored devices are reachable or 'up'.  However, some Kubernetes clusters prohibit the execution of binaries such as fping that require privileged capabilities (such as a set setuid bit or Linux privileged network capabilities).  For deployment in such clusters, you must instruct LibreNMS to "ping" devices using SNMP.  To enable this, invoke helm like:

    helm install librenms \
      --generate-name \
      --values values.yaml \
      --namespace librenms \
      --set snmpPing.enabled=true \
      --set credentials.application.key=... \
      --set librenmsServices.mysql.storage.type=... \
      --set librenmsServices.rrdcached.storage.type=... \
      --set librenmsServices.redis.storage.type=...

Setting the snmpPing.enabled key to 'true' causes LibreNMS to perform all "pinging" -- during device addition, discovery, and polling -- using the snmpstatus command rather than fping.

> In the current release, the SNMP ping option applies to *all* devices monitored by the installation.  In the future, it may be possible to choose fping (ICMP) or snmpstatus (SNMP) testing separately for each device.

Of course you should choose the appropriate storage type for each supporting service and provide the required supplementary values as described above.

### Non-Ingress Cluster

If your Kubernetes cluster does not support the Nginx Ingress Controller, you must use either a ClusterIP only service or a LoadBalancer service to access your WebUI and API.

> If you have modeled your values.yaml file as recommended above, you may remove all the Application keys (serviceType and ingressHost) when deploying to a non-ingress cluster.

##### LoadBalancer Service

If your cluster supports LoadBalancer services, you can use one to provide access to the application.  The details for setting configuring a load balancer service differ slightly by cluster provider, but typically you will first create the namespace for the installation:

    kubectl create namespace librenms

Then you can use the kubectl tool to create a service resource in that namespace using YAML that is something like:

    apiVersion: v1
    kind: Service
    metadata:
      namespace: librenms
      name: application
    spec:
      type: LoadBalancer
      loadBalancerSourceRanges:
      - 0.0.0.0/0
      externalTrafficPolicy: Local
      selector:
        component: application
      ports:
      - name: application
        port: 80
        targetPort: application

You may choose any port (spec.ports.port) on which to expose your application, but the pod selector label (spec.selector.component) and target port (spec.ports.targetPort) must both be set to 'application'

After creating the load balancer service, you may deploy the chart.  When invoking helm, you must indicate how your load balancer service can be reached -- either by IP address or hostname -- by supplying the base URL for the application, like:

    helm install librenms \
      --generate-name \
      --values values.yaml \
      --namespace librenms \
      --set credentials.application.key=$(docker run --rm tpboudreau/librenms-generate-key) \
      --set Application.serviceType=loadBalancer \
      --set Application.baseURL='http://n.n.n.n/' \
      --set librenmsServices.mysql.storage.type=temporary \
      --set librenmsServices.rrdcached.storage.type=temporary \
      --set librenmsServices.redis.storage.type=temporary

If you have chosen a port other than 80 (for http:) or 443 (for https:) you should include the port number in your base URL.

Of course you should choose the appropriate storage type for each supporting service and provide the required supplementary values as described above.

##### ClusterIP Service

Alternatively, to instruct helm to create only a ClusterIP service for LibreNMS, invoke helm like:

    helm install librenms \
      --generate-name \
      --values values.yaml \
      --namespace librenms \
      --set credentials.application.key=$(docker run --rm tpboudreau/librenms-generate-key) \
      --set Application.serviceType=cluster \
      --set librenmsServices.mysql.storage.type=... \
      --set librenmsServices.rrdcached.storage.type=... \
      --set librenmsServices.redis.storage.type=...

Setting the Application.serviceType to 'cluster' will cause Kubernetes to assign to the application service an address drawn from the pool of private addresses reserved for use by your cluster.  Neither this private address nor the cluster-local FQDN created for this service will be directly reachable from outside the cluster.  To access the application you will need to use a DNS server running outside the cluster to route external traffic directed to the application service FQDN into your cluster.  The steps required for this are beyond the scope of this document.

Of course you should choose the appropriate storage type for each supporting service and provide the required supplementary values as described above.

### Future Work

 - Implement gateway/ingress to support services for remote dispatchers
 - Provide support for additional ingress controllers
 - Implement safe upgrades to new versions
 - Implement on-demand or periodic credential rotation job
 - Implement on-demand or periodic database backup job(s)

