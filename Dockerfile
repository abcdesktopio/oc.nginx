
FROM ubuntu:20.04 

LABEL MAINTAINER="Alexandre DEVELY"

RUN DEBIAN_FRONTEND=noninteractive \
    echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
    apt-get update  -y  && 	\
    apt-get upgrade -y  && 	\
    apt-get install -y   --no-install-recommends 	\
	openssl			\
	ca-certificates		\
	nginx-extras 		\
	sed 			\
	luarocks		\
	gcc			\
        git			&& \
    apt-get clean

# git command is used by luarocks install lua-resty-rsa

# install luarocks package 
RUN DEBIAN_FRONTEND=noninteractive 				\
	luarocks install lua-resty-jwt 0.2.0-0 		&& 	\
        luarocks install lua-resty-string 0.09-0	&&	\
        luarocks install lua-cjson 2.1.0.6-1		&&	\
        luarocks install lua-resty-rsa 0.04-0 

# for debug only
# remove in release
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y  --no-install-recommends \
	net-tools 	\
	iputils-ping	\
	curl		\
	dnsutils        \
	vim		&& \
	apt-get clean

RUN 	mkdir -p /var/nginx/cache 	&& 	\
	mkdir -p /var/nginx/tmp 	&&	\
	mkdir -p /config 

# makefile use git info, copy .git then remove it
COPY .git /.git
COPY var/webModules /var/webModules
COPY etc/nginx /etc/nginx
COPY composer /composer
COPY config.payload.default/ /config.payload.default
COPY config.signing.default/ /config.signing.default

# Install nodejs
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash  && apt-get clean

#Install yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get install -y  --no-install-recommends \
	nodejs 	\
	make	&& \
	apt update && \
	apt install yarn && \
	apt-get clean

RUN  apt-get clean 

RUN yarn global add less minify

RUN apt-get install -y git \
	&& cd /var/webModules && make -B prod \
	&& apt-get -y remove git \
	&& apt-get -y purge git 

RUN rm -rf /.git 

#
# Uninstall build packages
# Keep this package to support update, make changes on ui.json for example
# RUN npm uninstall -g less minify
## install git for versionning
RUN apt-get -y remove 				\
		git 				\
		build-essential 		\
		gcc 				\
		binutils 			\
    && apt autoremove -y

EXPOSE 80 443
CMD ["/composer/docker-entrypoint.sh"]
