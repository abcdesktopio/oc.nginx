FROM abcdesktopio/oc.nginx:builder as builder

# default branch
ARG BRANCH=3.3

# convert ARG to ENV with same name
ENV BRANCH=$BRANCH
RUN echo BRANCH=$BRANCH

# copy data files 
# from abcdesktopio/webModules repo or from your local directory
# COPY /var/webModules /var/webModules 
# -- or --
RUN git clone -b $BRANCH https://github.com/abcdesktopio/webModules.git /var/webModules

#
# run makefile step by step 
# to get troubleshooting info
#
RUN cd /var/webModules && make install
RUN cd /var/webModules && make updatejs
RUN cd /var/webModules && make dev 
RUN cd /var/webModules && ./mkversion.sh

# RUN cd /var/webModules && make untranspile
# RUN cd /var/webModules/transpile && npm audit fix
# RUN cd /var/webModules && npm i --package-lock-only && npm audit fix


# --- START Build image ---
FROM nginx
COPY --from=builder var/webModules /usr/share/nginx/html
EXPOSE 80 
