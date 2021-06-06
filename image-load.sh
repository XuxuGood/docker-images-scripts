#!/bin/bash

# 定义日志
workdir=`pwd`
log_file=${workdir}/sync_images_$(date +"%Y-%m-%d").log

logger ()
{
    log=$1
    current_time='['$(date +"%Y-%m-%d %H:%M:%S")']'
    # 写入日志
    echo ${current_time} ${log} | tee -a ${log_file}
}

# 镜像压缩文件列表
images=$(cat images.txt | sed "s#/#-#g; s#:#-#g")

# 镜像压缩文件目录
images_path=xiaoxuxuy-images
cd $images_path

# 导入镜像
docker_load ()
{
    for img in $(echo ${images});
    do
        echo "===========开始导入镜像==========="
    	docker load < ${img}.tar.gz

        if [ $? -ne 0 ]; then
            logger "${imgs} load failed."
        else
            logger "${imgs} load successfully."
        fi
    done
}
docker_load

# 返回原目录
cd ..
