FROM debian:jessie-slim

ENV NGINX_VERSION=1.12.1

# install system packages
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
      build-essential \
      git \
      libpcre3-dev \
      zlib1g-dev \
      curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && adduser --system --group --no-create-home --disabled-login --disabled-password nginx \

    # install nginx
    && curl -LO http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz \
    && tar zxf nginx-${NGINX_VERSION}.tar.gz \
    && cd nginx-${NGINX_VERSION} \
    && git -c http.sslVerify=false clone https://github.com/evanmiller/mod_zip.git \
    && ./configure \
        --prefix=/usr \
        --user=nginx \
        --group=nginx \
        --http-log-path=/dev/stdout \
        --error-log-path=/dev/stdout \
        --with-pcre-jit \
        --with-file-aio \
        --with-threads \
        --with-http_realip_module \
        --with-http_addition_module \
        --with-http_gzip_static_module \
        --with-http_gunzip_module \
        --with-http_sub_module \
        --add-module=mod_zip \
    && make install \

    && mkdir -p /var/www/html /etc/nginx/conf.d /etc/nginx/sites-enabled \

    && cp ./conf/mime.types /etc/nginx/mime.types

    && cd .. \
    && rm -f nginx-${NGINX_VERSION}.tar.gz \
    && rm -rf nginx-${NGINX_VERSION} \

COPY init /
COPY nginx.conf /etc/nginx/
COPY sec.conf /etc/nginx/sites-enabled

CMD [ "/init", "-c", "/etc/nginx/nginx.conf" ]
