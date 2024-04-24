FROM debian:trixie-slim as builder
RUN apt-get update -y;
RUN apt-get upgrade -y;

RUN apt-get install -y build-essential
RUN apt-get install -y cmake
RUN apt-get install -y git
RUN apt-get install -y gnupg
RUN apt-get install -y golang
RUN apt-get install -y curl
RUN apt-get install -y libpcre3-dev
RUN apt-get install -y zlib1g-dev
RUN apt-get install -y wget
RUN apt-get install -y libgd-dev
RUN apt-get install -y libxslt-dev

# openssl
ENV OPENSSL_PATH="/ngx/modules"
RUN mkdir -p $OPENSSL_PATH
WORKDIR  $OPENSSL_PATH

# QuicTLS is one of the recommended SSL libraries with QUIC support (https://nginx.org/en/docs/quic.html)
# We have stable backup version of quictls/openssl
RUN git clone --depth 1 --recursive https://github.com/webpanorg/openssl
# Use original version of quictls/openssl
# RUN git clone --depth 1 --recursive https://github.com/quictls/openssl

# ----- PREPARE NJS ------ #
ENV NJS_VERSION 0.8.2
ENV NJS_PATH="/tmp/njs"

WORKDIR $NJS_PATH
RUN git clone --branch $NJS_VERSION --depth=1 --recursive --shallow-submodules https://github.com/nginx/njs njs

# ----- PREPARE BROTLI ------ #
ENV BROTLI_PATH="/tmp/brotli"

WORKDIR $BROTLI_PATH
RUN git clone --depth=1 --recursive --shallow-submodules https://github.com/google/ngx_brotli


ENV NGINX_VERSION 1.25.2
ENV NGINX_PATH="/opt/nginx"

WORKDIR $NGINX_PATH
RUN wget http://nginx.org/download/nginx-$NGINX_VERSION.tar.gz
RUN tar -xzvf nginx-${NGINX_VERSION}.tar.gz
WORKDIR /${NGINX_PATH}/nginx-${NGINX_VERSION}


RUN ./configure \
  --with-openssl="$OPENSSL_PATH/openssl/" \
  --prefix=/etc/nginx \
  --sbin-path=/usr/sbin/nginx \
  --modules-path=/usr/lib/nginx/modules \
  --conf-path=/etc/nginx/nginx.conf \
  --error-log-path=/var/log/nginx/error.log \
  --http-log-path=/var/log/nginx/access.log \
  --pid-path=/var/run/nginx.pid \
  --lock-path=/var/run/nginx.lock \
  --http-client-body-temp-path=/var/cache/nginx/client_temp \
  --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
  --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
  --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
  --http-scgi-temp-path=/var/cache/nginx/scgi_temp \
  --with-pcre-jit \
  --with-http_ssl_module \
  --with-http_realip_module \
  --with-http_addition_module \
  --with-http_sub_module \
  --with-http_dav_module \
  --with-http_flv_module \
  --with-http_mp4_module \
  --with-http_image_filter_module \
  --with-http_gunzip_module \
  --with-http_gzip_static_module \
  --with-http_random_index_module \
  --with-compat \
  --with-file-aio \
  --with-http_v2_module \
  --with-http_v3_module \
  --with-select_module \
  --with-poll_module \
  --add-module=$BROTLI_PATH/ngx_brotli \
  --add-module=$NJS_PATH/njs/nginx \
  --user=nginx \
  --group=nginx 

RUN make
RUN make install

# Production

FROM debian:trixie-slim as production

# ADD NGINX USER
RUN groupadd -r nginx
RUN useradd -r -g nginx -s /bin/false -M nginx

RUN mkdir -p /var/run/
RUN mkdir -p /var/log/nginx
RUN mkdir -p /usr/lib/nginx/modules
RUN mkdir -p /var/cache/nginx
RUN mkdir -p /var/cache/nginx/client_temp
RUN mkdir -p /var/cache/nginx/proxy_temp
RUN mkdir -p /var/cache/nginx/fastcgi_temp
RUN mkdir -p /var/cache/nginx/uwsgi_temp
RUN mkdir -p /var/cache/nginx/scgi_temp

COPY --from=builder /usr/sbin/nginx /usr/sbin/nginx
RUN chmod 0755 /usr/sbin/nginx

RUN mkdir /etc/nginx
COPY --from=builder /etc/nginx /etc/nginx
COPY --from=builder /usr/lib /usr/lib

STOPSIGNAL SIGTERM
EXPOSE 80 443

# Forward request and error logs to docker log collector to get output
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log 

CMD ["/usr/sbin/nginx", "-g", "daemon off;"]
