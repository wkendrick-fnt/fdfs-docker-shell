FROM alpine
RUN sed '1i http://mirrors.aliyun.com/alpine/' /etc/apk/repositories && apk update && apk add --no-cache build-base make cmake gcc automake autoconf libtool pcre pcre-dev zlib zlib-dev openssl openssl-dev git \
&& mkdir -p /usr/local/src && cd /usr/local/src \
&& git clone https://github.com/happyfish100/libfastcommon.git \
&& git clone https://github.com/happyfish100/fastdfs.git \
&& git clone https://github.com/happyfish100/fastdfs-nginx-module.git \
&& git clone https://github.com/wkendrick-fnt/fdfs-docker-shell.git \
&& wget http://labs.frickle.com/files/ngx_cache_purge-2.3.tar.gz && tar -zxvf ngx_cache_purge-2.3.tar.gz \
&& wget http://nginx.org/download/nginx-1.14.2.tar.gz && tar -zxvf nginx-1.14.2.tar.gz \

&& cd /usr/local/src/libfastcommon && sh make.sh &&sh make.sh install \
&& cd /usr/local/src/fastdfs && sh make.sh &&sh make.sh install \
&& cd /usr/local/src/nginx-1.14.2 && sh configure --prefix=/usr/local/nginx --add-module=/usr/local/src/fastdfs-nginx-module/src && make && make install && cp /usr/local/nginx/sbin/nginx /usr/local/nginx/sbin/nginx-fastdfs-module \
&& cd /usr/local/src/nginx-1.14.2 && sh configure --prefix=/usr/local/nginx --add-module=/usr/local/src/ngx_cache_purge-2.3 && make && make install && cp /usr/local/nginx/sbin/nginx /usr/local/nginx/sbin/nginx-cache-purge \
&& cd /usr/local/src/nginx-1.14.2 && sh configure --prefix=/usr/local/nginx && make && make install \
&& cd /usr/local/src/fastdfs/conf && cp http.conf mime.types /etc/fdfs/ \
&& mv /etc/fdfs/client.conf.sample /etc/fdfs/client.conf && mv /etc/fdfs/storage_ids.conf.sample /etc/fdfs/storage_ids.conf && mv /etc/fdfs/storage.conf.sample /etc/fdfs/storage.conf && mv /etc/fdfs/tracker.conf.sample /etc/fdfs/tracker.conf && cp /usr/local/src/fastdfs-nginx-module/src/mod_fastdfs.conf /etc/fdfs/ && mv /usr/local/src/fdfs-docker-shell/entrypoint.sh / \
&& mkdir -p /home/yuqing/fastdfs \
&& mkdir -p /home/yuqing/fastdfs/cache/nginx/proxy_cache \
&& mkdir -p /home/yuqing/fastdfs/cache/nginx/proxy_cache/tmp \
&& fdfs_storaged /etc/fdfs/storage.conf start && /usr/local/nginx/sbin/nginx \
&& rm -rf /usr/local/src && apk del build-base make cmake gcc automake autoconf libtool pcre-dev zlib zlib-dev openssl openssl-dev git
ENTRYPOINT [ "sh", "entrypoint.sh" ]
