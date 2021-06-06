#!/usr/bin/env bash

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

# 镜像清单文件
list="images.txt"

rm -rf xiaoxuxuy-images/
mkdir -p xiaoxuxuy-images

for i in $(cat ${list});
do
    echo "===========开始拉取镜像==========="
    # 拉取镜像
    docker pull ${i}
    
    if [ $? -ne 0 ]; then
        logger "${i} pull failed."
    else
        logger "${i} pull successfully."
    fi

    echo "===========开始镜像转存==========="
    # 镜像保存成 tar 归档文件
    docker save ${i} | gzip > xiaoxuxuy-images/$(echo $i | sed "s#/#-#g; s#:#-#g").tar.gz

    if [ $? -ne 0 ]; then
        logger "${i} save failed."
    else
        logger "${i} save successfully."
    fi
done
