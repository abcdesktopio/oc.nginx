# oc.nginx
![Update oc.nginx](https://github.com/abcdesktopio/oc.nginx/workflows/build%20oc.nginx/badge.svg)
![Docker Stars](https://img.shields.io/docker/stars/abcdesktopio/oc.nginx.svg) ![Docker Pulls](https://img.shields.io/docker/pulls/abcdesktopio/oc.nginx.svg)


# abcdesktop.io DockerFile Front Web

## to clone source code 

```
git clone https://github.com/abcdesktopio/oc.nginx.git
```

## to build a new oc.nginx container image

### using branch=main 

```
docker buildx build --build-arg BRANCH=main --build-arg BASE_IMAGE_RELEASE=jammy --build-arg BASE_IMAGE=openresty/openresty --file Dockerfile  .
```

### using branch=3.2 

```
docker buildx build --build-arg BRANCH=3.2 --build-arg BASE_IMAGE_RELEASE=jammy --build-arg BASE_IMAGE=openresty/openresty --file Dockerfile  .
```
