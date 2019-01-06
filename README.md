# fdfs-docker-shell
个人自用docker的fdfs，直接构建不压缩占34MB大小。

需要根据自己情况，自行修改配置文件

fdfs配置文件目录为/etc/fdfs

fdfs的数据文件目录为/home/yuqing/fastdfs

nginx的配置文件目录为/usr/local/nginx/conf

启动脚本 


设置了ENTRYPOINT [ "sh", "entrypoint.sh" ]，docker run ... tracker  启动tracker，docker run ... storage  启动storage

压缩会丢失，ENTRYPOINT，启动需要输入完整shell命令

sh entrypoint.sh tracker      

启动tracker

sh entrypoint.sh storage      

启动storage
