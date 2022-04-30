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
    apt-get install -y   				\
	build-essential			                \
        git			                        \
	gnupg						\
	ca-certificates					\
	curl						\
	dpkg						\
	python						\
	python3						\
    && apt-get clean					\
    && rm -rf /var/lib/apt/lists/

# Install nodejs
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash && \
    curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | tee /usr/share/keyrings/yarnkey.gpg >/dev/null && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install -y yarn

RUN yarn global add less minify
