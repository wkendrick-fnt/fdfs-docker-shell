#!/bin/sh
#set -e


TRACKER_BASE_PATH="/home/yuqing/fastdfs"
TRACKER_LOG_FILE="$TRACKER_BASE_PATH/logs/trackerd.log"

STORAGE_BASE_PATH="/home/yuqing/fastdfs"
STORAGE_LOG_FILE="$STORAGE_BASE_PATH/logs/storaged.log"

TRACKER_CONF_FILE="/etc/fdfs/tracker.conf"
STORAGE_CONF_FILE="/etc/fdfs/storage.conf"

NGINX_ACCESSLOG="/usr/local/nginx/logs/access.log"
NGINX_ERRORLOG="/usr/local/nginx/logs/error.log"

if [  -d "/home/yuqing/fastdfs/logs" ]; then 
	rm -rf "/home/yuqing/fastdfs/logs"
fi

if [  -d "/home/yuqing/fastdfs/logs" ]; then 
	rm -rf "/home/yuqing/fastdfs/logs"
fi

if [ ! -d "/home/yuqing/fastdfs/cache/nginx/proxy_cache" ]; then 
	mkdir -p "/home/yuqing/fastdfs/cache/nginx/proxy_cache" 
fi 

if [ "$1" = 'sh' ]; then
	/bin/sh
fi

if [ "$1" = 'tracker' ]; then
	echo "start  fdfs_trackerd..."

	if [ ! -d "/home/yuqing/fastdfs/logs" ]; then 
		mkdir -p "/home/yuqing/fastdfs/logs" 
	fi 

	/usr/local/nginx/sbin/nginx-cache-purge

	sh /etc/init.d/fdfs_trackerd start

	sleep 3s

	touch  "$TRACKER_LOG_FILE"
	ln -sf /dev/stdout "$TRACKER_LOG_FILE"
	
	tail -fn 100 /usr/local/nginx/logs/access.log /usr/local/nginx/logs/error.log
 fi

if [ "$1" = 'storage' ]; then
	echo "start  fdfs_storgaed..."

	if [ ! -d "/home/yuqing/fastdfs/logs" ]; then 
		mkdir -p "/home/yuqing/fastdfs/logs" 
	fi 

	/usr/local/nginx/sbin/nginx-fastdfs-module

	sh /etc/init.d/fdfs_storaged start

	sleep 3s

	touch  "$STORAGE_LOG_FILE"
	ln -sf /dev/stdout "$STORAGE_LOG_FILE"

	tail -fn 100 /usr/local/nginx/logs/access.log /usr/local/nginx/logs/error.log
fi
