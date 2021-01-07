ifdef ${NOCACHE}
  NOCACHE=${NOCACHE}
else
  NOCACHE=false
endif

all:  nginx

nginx:
	@echo "no-cache=${NOCACHE}"
	docker pull ubuntu:20.04
	docker build --no-cache=$(NOCACHE) -t oc.nginx -f oc.nginx .
	docker tag oc.nginx abcdesktop/oio:oc.nginx
push: 
	docker push abcdesktop/oio:oc.nginx
