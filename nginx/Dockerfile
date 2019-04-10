FROM nginx:alpine

# Rebuild nginx with mod_zip so we can serve zippped lesson plans.
RUN apk add --no-cache --virtual .build-deps \
		gcc \
		libc-dev \
		make \
		pcre-dev \
		zlib-dev \
		linux-headers \
		curl \
		libxslt-dev \
		gd-dev \
    git \
    && curl -LO https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz \
    && tar zxf nginx-${NGINX_VERSION}.tar.gz \
    && cd nginx-${NGINX_VERSION} \
    && git -c http.sslVerify=false clone https://github.com/evanmiller/mod_zip.git \
    && ./configure \
        --prefix=/usr \
        --user=nginx \
        --group=nginx \
        --conf-path=/etc/nginx/nginx.conf \
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
    && cd .. \
    && rm -f nginx-${NGINX_VERSION}.tar.gz \
    && rm -rf nginx-${NGINX_VERSION} \
    && apk del .build-deps \
    && mkdir -p /etc/nginx/sites-enabled

COPY nginx.conf /etc/nginx/nginx.conf
COPY sec.conf /etc/nginx/sites-enabled
