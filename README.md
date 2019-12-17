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

