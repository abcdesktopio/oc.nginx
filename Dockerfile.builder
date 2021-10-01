FROM ubuntu:20.04 

#
# This docker file is a builder docker file
# use to build oc.nginx docker file 
# Install nodejs, yarn, lessc, git 
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
