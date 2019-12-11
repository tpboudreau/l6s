# l6s
WIP LibreNMS k8s+helm

Options for databases instances (mysql and rrdcached):

- cluster (typical clusterip service created, pods are created to run mysql and rrdcached)
- external (non-selecting clusterip service + endpoints routing to provided address:port)

Options for application service (for webUI/API):

- clusterip only (DNS routing external)
- loadbalancer (http only (later https) + whitelist, for cloud k8s)
- ingress (with NodePoint cluster service, ingress controller handles SSL)

Options for database services (for dispatchers):

- clusterip(s) only (valid if no remote pollers/dispatchers or external DNS routing per service)
- loadbalancer(s) (dangerous without ACLs anywhere in route)
- one load balancer (requires lightweight static gateway proxy to route and enforce ACLs -- proxy protocol would be ideal, but requires controllers in pods)
- ingress(es) (provided TCP routing is supported to route and enforce ACLs -- proxy protocol would be ideal, but requires controllers in pods)

Options for credential rotation:

- never
- periodic

Options for application update:

- never
- periodic
