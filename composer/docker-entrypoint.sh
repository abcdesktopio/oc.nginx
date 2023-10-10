#!/bin/bash

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
#/usr/sbin/nginx
/usr/local/openresty/nginx/sbin/nginx -p /etc/nginx -c nginx.conf -e /var/log/nginx/error.log
