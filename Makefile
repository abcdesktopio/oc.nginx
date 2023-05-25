ifdef ${NOCACHE}
  NOCACHE=${NOCACHE}
else
  NOCACHE=false
endif

all:  nginx

nginx:
	@echo "no-cache=${NOCACHE}"
	docker build --no-cache=$(NOCACHE) -t oc.nginx:dev .
	docker tag oc.nginx:dev abcdesktopio/oc.nginx:dev
push: 
	docker push abcdesktopio:oc.nginx:dev
