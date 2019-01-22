FROM alpine:latest

ARG php-version=5.4.37
ARG node-version=0.12.0
ARG npm-version=2.7.4
ARG nginx-version=1.10.2

RUN apk add --update --no-cache curl ca-certificates nodejs=${node-version} nodejs-npm=${npm-version}
RUN apk --update --no-cache add --virtual .build \
  gcc g++ make re2c bison \
  linux-headers libxml2-dev curl-dev libpng-dev postgresql-dev zlib-dev libsodium-dev argon2-dev pcre-dev

WORKDIR /usr/src/php

RUN wget -qO - http://php.net/distributions/php-${php-version}.tar.gz | tar -xz --strip-components=1
RUN ./configure \
  --prefix=/opt/php/ \
  --sbindir=/opt/php/bin \
  --with-config-file-path="/opt/php/etc" \
  --with-config-file-scan-dir="/opt/php/etc/conf.d" \
  --enable-fpm \
  --enable-bcmath \
  --enable-filter \
  --enable-mbstring \
  --enable-opcache \
  --enable-simplexml \
  --enable-xmlreader \
  --enable-xmlwriter \
  --enable-zip \
  --with-curl \
  --with-gd \
  --with-pdo-pgsql \
  --with-password-argon2 \
  --with-sodium \
  --disable-phpdbg \
  --disable-phpdbg-webhelper \
  --with-openssl \
  --with-zlib 
RUN make -j $(nproc) && make install

WORKDIR /usr/src/nginx

RUN wget -qO - https://nginx.org/download/nginx-${nginx-version}.tar.gz | tar -xz --strip-components=1
RUN ./configure \
  --prefix=/opt/nginx/etc \
  --sbin-path=/opt/nginx/bin/nginx \
  --modules-path=/opt/nginx/usr/lib/nginx/modules \
  --conf-path=/opt/nginx/etc/nginx.conf \
  --error-log-path=/opt/nginx/var/log/nginx/error.log \
  --http-log-path=/opt/nginx/var/log/nginx/access.log \
  --pid-path=/opt/nginx/var/run/nginx.pid \
  --lock-path=/opt/nginx/var/run/nginx.lock \
  --http-client-body-temp-path=/tmp/nginx/client_temp \
  --http-proxy-temp-path=/tmp/nginx/proxy_temp \
  --http-fastcgi-temp-path=/tmp/nginx/fastcgi_temp \
  --http-uwsgi-temp-path=/tmp/nginx/uwsgi_temp \
  --http-scgi-temp-path=/tmp/nginx/scgi_temp \
  --user=www-data \
  --group=www-data \
  --with-http_ssl_module \
  --with-http_realip_module \
  --with-http_addition_module \
  --with-http_sub_module \
  --with-http_gzip_static_module \
  --with-http_random_index_module \
  --with-http_secure_link_module \
  --with-threads \
  --with-stream \
  --with-stream_ssl_module \
  --with-stream_ssl_preread_module \
  --with-stream_realip_module \
  --with-http_slice_module \
  --with-compat \
  --with-file-aio \
  --with-http_v2_module \
  --with-debug
RUN make -j $(nproc) && make install

