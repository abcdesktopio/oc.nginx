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
	# sed -i "s/127.0.0.11/kube-dns.kube-system.svc.cluster.local./g" 	/etc/nginx/sites-enabled/default 
	RESOLVER=$(grep -m 1 nameserver /etc/resolv.conf | awk '{ print $2 }')
        sed -i "s/127.0.0.11/$RESOLVER/g" /etc/nginx/sites-enabled/default
	sed -i "s/pyos/pyos.abcdesktop.svc.cluster.local./g" 			/etc/nginx/sites-enabled/default
	PYOS=pyos.abcdesktop.svc.cluster.local.
fi


if [ -z "$JWT_DESKTOP_PAYLOAD_PRIVATE_KEY" ]
then
   echo "JWT_DESKTOP_PAYLOAD_PRIVATE_KEY is not defined, settings to default value"
   export JWT_DESKTOP_PAYLOAD_PRIVATE_KEY="/config.payload/abcdesktop_jwt_desktop_payload_private_key.pem"
fi

if [ -z "$JWT_DESKTOP_SIGNING_PUBLIC_KEY" ]
then
   echo "JWT_DESKTOP_SIGNING_PUBLIC_KEY is not defined, settings to default value"
   export JWT_DESKTOP_SIGNING_PUBLIC_KEY="/config.signing/abcdesktop_jwt_desktop_signing_public_key.pem"
fi

if [ ! -d "/config.signing" ]; then
  mv /config.signing.default /config.signing
fi

if [ ! -d "/config.payload" ]; then
  mv /config.payload.default /config.payload
fi

if [ -n "$DEMO_ABCDESKTOP_IO" ]; then
	echo 'demo mode is detected'
	echo 'replace file index.html by demo.html'
	cp /var/webModules/demo.html /var/webModules/index.html
else
	echo 'running standart configuration file'
fi

# troubleshooting LB 
# add node node to node.txt
echo "$NODE_NAME" > /var/webModules/node.txt

# run dump env var
printenv > /tmp/env.log

# start nginx web server
/usr/sbin/nginx 
