# Default release is 20.04
ARG BASE_IMAGE_RELEASE=20.04
# Default base image 
ARG BASE_IMAGE=ubuntu

# --- START Build image ---
FROM $BASE_IMAGE:$BASE_IMAGE_RELEASE


#
# This docker file is a builder docker file
# this is a make container image for oc.nginx 
# use to build oc.nginx docker file 
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
    && apt-get clean

# Install nodejs
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash  && apt-get clean

#Install yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update && \
    apt-get install -y  --no-install-recommends \
        nodejs  \
        yarn    \
        make    \
        && apt-get clean

RUN yarn global add less minify
