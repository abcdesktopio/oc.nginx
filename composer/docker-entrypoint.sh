#!/bin/bash

PYOS=pyos

# check if the the container is running inside a KUBERNETES
# by testing the env $KUBERNETES_SERVICE_HOST
if [ -z "$KUBERNETES_SERVICE_HOST" ]
then
	echo 'Kubernetes is not detected' 
	echo 'Using default config file'
else
	# replace 127.0.0.11 	by FQDN kube-dns.kube-system.svc.cluster.local
        # replace pyos 		by FQDN pyos.default.svc.cluster.local
	sed -i "s/127.0.0.11/kube-dns.kube-system.svc.cluster.local./g" 	/etc/nginx/sites-enabled/default 
	sed -i "s/pyos/pyos.abcdesktop.svc.cluster.local./g" 			/etc/nginx/sites-enabled/default
	PYOS=pyos.abcdesktop.svc.cluster.local.
fi


if [ ! -d "/config.signing" ]; then
  mv /config.signing.default /config.signing
fi

if [ ! -d "/config.payload" ]; then
  mv /config.payload.default /config.payload
fi

/usr/sbin/nginx 
