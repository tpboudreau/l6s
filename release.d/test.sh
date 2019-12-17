
helm install \
  --generate-name \
  --values values.yaml \
  --namespace librenms \
  --set snmpPing.enabled=true \
  --set Application.serviceType=ingress \
  --set librenmsServices.mysql.storage.type=temporary \
  --set librenmsServices.rrdcached.storage.type=temporary \
  --set librenmsServices.redis.storage.type=temporary \
  librenms

  #--dry-run \

#---

#helm template \
#  --generate-name \
#  --values values.yaml \
#  --namespace librenms-temporary \
#  --set librenmsServices.mysql.storage.type=temporary \
#  --set librenmsServices.rrdcached.storage.type=temporary \
#  --set librenmsServices.redis.storage.type=temporary \
#  --dry-run \
#  librenms

#---

#helm install \
#  --generate-name \
#  --values values.yaml \
#  --namespace librenms \
#  --set librenmsServices.mysql.storage.claimName=mysql-volume \
#  --set librenmsServices.rrdcached.storage.claimName=rrdcached-volume \
#  --set librenmsServices.redis.storage.claimName=redis-volume \
#  --dry-run \
#  librenms

#--------

#helm template \
#  --generate-name \
#  --values values.yaml \
#  --namespace librenms-temporary \
#  --set snmpPing.enabled=true \
#  --set librenmsServices.mysql.storage.type=temporary \
#  --set librenmsServices.rrdcached.storage.type=temporary \
#  --set librenmsServices.redis.storage.type=temporary \
#  --dry-run \
#  librenms

#--------

#helm install \
#  --generate-name \
#  --values values.yaml \
#  --namespace librenms \
#  --set librenmsServices.mysql.external.enabled=true,librenmsServices.mysql.external.address=12.34.56.78,librenmsServices.mysql.external.port=3333 \
#  --set librenmsServices.rrdcached.external.enabled=true,librenmsServices.rrdcached.external.address=12.34.56.78,librenmsServices.rrdcached.external.port=4444 \
#  --dry-run \
#  librenms

#--------

#helm template \
#  --generate-name \
#  --values values.yaml \
#  --namespace librenms \
#  --set snmpPing.enabled=true \
#  --set Application.serviceType=ingress \
#  --set librenmsServices.mysql.external.enabled=true,librenmsServices.mysql.external.address=12.34.56.78,librenmsServices.mysql.external.port=3306 \
#  --set librenmsServices.rrdcached.external.enabled=true,librenmsServices.rrdcached.external.address=12.34.56.78,librenmsServices.rrdcached.external.port=42217 \
#  --set librenmsServices.redis.storage.claimName=redis-volume \
#  --dry-run \
#  librenms

