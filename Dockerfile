FROM abcdesktopio/oc.nginx:builder as builder

# copy .git for version
COPY .git /.git
# copy data files
COPY var/webModules /var/webModules
# run makefile 
RUN cd /var/webModules && make -B prod 


# --- START Build image ---
FROM ubuntu:20.04

RUN DEBIAN_FRONTEND=noninteractive \
    echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
    apt-get update      && 	                        \
    apt-get install -y   --no-install-recommends 	\
        nginx-extras                                	\
    	sed 			                        \
    && apt-get clean


# git command is used by luarocks install lua-resty-rsa

# install luarocks package 
RUN DEBIAN_FRONTEND=noninteractive			\
    apt-get update      && 	                        \
    apt-get install -y   --no-install-recommends 	\
        luarocks		                        \
	build-essential			        	\
        git			                        \
    &&                                              	\    
        luarocks install lua-resty-jwt 0.2.0-0 		&& 	\
        luarocks install lua-resty-string 0.09-0	&&	\
        luarocks install lua-cjson 2.1.0.6-1		&&	\
        luarocks install lua-resty-rsa 0.04-0       	&&  	\
    apt-get remove -y	                                	\
        luarocks		                            	\
	build-essential			  	                \
        git			                                \
    && apt-get clean

# for debug only
# remove in release
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y  --no-install-recommends \
	net-tools 	\
	iputils-ping	\
	curl		\
	dnsutils        \
	vim		\
	&& apt-get clean

RUN 	mkdir -p /var/nginx/cache 	&& 	\
	mkdir -p /var/nginx/tmp 	&&	\
	mkdir -p /config 

# COPY generated web site from builder container
COPY --from=builder var/webModules /var/webModules

COPY etc/nginx /etc/nginx
COPY composer /composer
COPY config.payload.default/ /config.payload.default
COPY config.signing.default/ /config.signing.default

EXPOSE 80 443
CMD ["/composer/docker-entrypoint.sh"]
