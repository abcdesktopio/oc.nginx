# Default release is 20.04
ARG BASE_IMAGE_RELEASE=jammy
# Default base image 
ARG BASE_IMAGE=openresty/openresty

FROM abcdesktopio/oc.nginx:builder as builder

# copy .git for version
COPY .git /.git
# copy data files
# COPY var/webModules /var/webModules
RUN cd /var && git clone https://github.com/abcdesktopio/webModules.git
#
# run makefile 
RUN cd /var/webModules && make install
RUN cd /var/webModules && make updatejs
RUN cd /var/webModules && make dev 
RUN cd /var/webModules && ./mkversion.sh

# RUN cd /var/webModules && make untranspile
# RUN cd /var/webModules/transpile && npm audit fix
# RUN cd /var/webModules && npm i --package-lock-only && npm audit fix


# --- START Build image ---
FROM $BASE_IMAGE:$BASE_IMAGE_RELEASE
# FROM openresty/openresty:jammy

RUN /usr/local/openresty/luajit/bin/luarocks install lua-resty-jwt && \
    /usr/local/openresty/luajit/bin/luarocks install lua-resty-string && \
    /usr/local/openresty/luajit/bin/luarocks install lua-cjson && \
    /usr/local/openresty/luajit/bin/luarocks install lua-resty-rsa

RUN mkdir -p /var/nginx/cache /var/nginx/tmp /config /var/log/nginx /etc/nginx/logs/

# COPY generated html file web site from builder container
# copy all files 
RUN mkdir -p /var/webModules
COPY --from=builder var/webModules /var/webModules

# copy all nginx configuration files
COPY etc/nginx /etc/nginx

# copy default abcdesktop docker-entrypoint.sh
COPY composer /composer

# copy default keys
COPY config.payload.default/ /config.payload.default
COPY config.signing.default/ /config.signing.default

EXPOSE 80 443
CMD ["/composer/docker-entrypoint.sh"]
