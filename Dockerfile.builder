ARG BASE_IMAGE_RELEASE=jammy
# Default base image 
ARG BASE_IMAGE=ubuntu

FROM $BASE_IMAGE:$BASE_IMAGE_RELEASE as builder

# default branch
ARG BRANCH=3.2

# convert ARG to ENV with same name
ENV BRANCH=$BRANCH

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
    apt-get update  -y && \
    apt-get install -y --no-install-recommends \
	build-essential			                \
        git			                        \
	gnupg						\
	ca-certificates					\
	curl						\
	dpkg						\
	python3						\
	devscripts 					\
	wget 						\
	ca-certificates					\
    && apt-get clean					\
    && rm -rf /var/lib/apt/lists/

# install yarn npm nodejs
ENV NODE_MAJOR=18 
RUN  mkdir -p /etc/apt/keyrings && \
     curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg && \
     echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list && \
     apt-get update && \
     apt-get install -y --no-install-recommends nodejs && \
     npm -g install yarn && \
     apt-get clean && \
     rm -rf /var/lib/apt/lists/

RUN yarn global add less minify
