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

