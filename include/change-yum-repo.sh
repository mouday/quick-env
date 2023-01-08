#!/usr/bin/bash

##################################
# 修改yum源为阿里云源
# https://developer.aliyun.com/mirror/centos
##################################

function change_yum_repo(){
    # 1. 备份
    now_time=$(date "+%Y-%m-%d_%H:%M:%S")
    mv /etc/yum.repos.d/CentOS-Base.repo "/etc/yum.repos.d/CentOS-Base.repo.backup.${now_time}"

    # 2. 下载新的 CentOS-Base.repo 到 /etc/yum.repos.d/
    # CentOS 7
    
    repo_filename="${QUICK_ENV_CACHE}/Centos-7.repo"

    if [ ! -e $repo_filename ]; then
        echo "Download Centos-7.repo"
        wget -O $repo_filename https://mirrors.aliyun.com/repo/Centos-7.repo
    fi

    cp $repo_filename /etc/yum.repos.d/CentOS-Base.repo
    
    # 4. 非阿里云ECS用户会出现 Couldn't resolve host 'mirrors.cloud.aliyuncs.com' 信息
    sed -i -e '/mirrors.cloud.aliyuncs.com/d' -e '/mirrors.aliyuncs.com/d' /etc/yum.repos.d/CentOS-Base.repo

    # 3. 运行 yum makecache 生成缓存
    yum makecache

    yum repolist

    # bugfix 
    # https://blog.csdn.net/winter_liang/article/details/54730888
    rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
}   

