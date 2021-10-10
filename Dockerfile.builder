# Default release is 20.04
ARG BASE_IMAGE_RELEASE=20.04
# Default base image 
ARG BASE_IMAGE=ubuntu

# --- START Build image ---
FROM $BASE_IMAGE:$BASE_IMAGE_RELEASE

#
# This docker file is a builder docker file
# this is like a makefile inside a container image 
# this image is used for oc.nginx 
# to build oc.nginx docker file 
#
# Install all build tools like 
# build-essential
# * nodejs 
# * yarn 
# * lessc
# * git 
# * make
#

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
    apt-get update  -y  && 	                        \
    apt-get install -y   --no-install-recommends 	\
	build-essential			                \
        git			                        \
	gnupg						\
	ca-certificates					\
	curl						\
	dpkg						\
    && apt-get clean					\
    && rm -rf /var/lib/apt/lists/

# Install nodejs
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN npm install -g yarn &&
    yarn global add less minify
