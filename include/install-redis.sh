#!/usr/bin/bash

##################################
# 安装 redis
##################################

default_version='5.0.10'

function get_redis_install_dir(){
    version=$1

    redis_install_dir="${QUICK_ENV_LOCAL}/redis-${version}"

    if [ -z $version ]; then
        redis_install_dir="${QUICK_ENV_LOCAL}/redis"
    fi

    echo $redis_install_dir
}

function install_redis(){
    # redis params
    version=$1

    redis_install_dir=`get_redis_install_dir $version`
    echo "redis_install_dir: ${redis_install_dir}"

    if [ ! $version ]; then
        version=$default_version
    fi

    redis_cache_filename="${QUICK_ENV_CACHE}/redis-${version}.tar.gz"
    redis_source_dir="${QUICK_ENV_CACHE}/redis-${version}"
    redis_download_url="https://repo.huaweicloud.com/redis/redis-${version}.tar.gz"

    if [ -e  $redis_install_dir ]; then
        echo "redis install dir exists: ${redis_install_dir}"
        return 0
    fi

    # 下载nginx
    if [ ! -e $redis_cache_filename ]; then
        echo "Download redis-${version}"
        wget $redis_download_url -O $redis_cache_filename
    fi

    # 解压
    if [ ! -e $redis_cache_filename ]; then
        echo "nginx cache file not exists!"
        exit 1
    fi

    tar -zxf $redis_cache_filename -C $QUICK_ENV_CACHE

    cd $redis_source_dir

    echo 'redis installing'
    # 1、安装编译工具
    yum --quiet --assumeyes install make gcc gcc-c++

    make >/dev/null 2>&1
    if [ "$?" -ne 0 ]; then
        echo "redis install error"
        return 1
    fi

    # 返回
    cd -
    mv "${redis_source_dir}" "${redis_install_dir}"

    # 软链
    if [ ! -e '/etc/profile.d/redis.sh' ]; then
        cat > /etc/profile.d/redis.sh <<EOF
# redis
export REDIS_HOME=${redis_install_dir}
export PATH="\$REDIS_HOME/src:\$PATH"
EOF
    fi

    # 开机自启
    if [ ! -e '/usr/lib/systemd/system/redis.service' ]; then
        /bin/cp "${QUICK_ENV_HOME}/init.d/redis.service" /usr/lib/systemd/system/redis.service
        sed -i "s@/usr/local/redis@${redis_install_dir}@g" /usr/lib/systemd/system/redis.service
    fi

    # 2、创建用户
    # id -u redis >/dev/null 2>&1
    # [ $? -ne 0 ] && useradd -M -s /sbin/nologin redis
    # chown -R redis:redis ${redis_install_dir}
    
    systemctl enable redis
    systemctl start redis

    echo '*************************************'
    echo '* redis install success'
    echo '* source /etc/profile.d/redis.sh'
    echo '* systemctl status redis'
    echo '*************************************'
}

function versions_redis(){
    curl 'https://repo.huaweicloud.com/redis/'

    for install_file in $install_files; do
        re="install-(.*).sh"
        if [[ $install_file =~ $re ]]; then 
            echo "  ${BASH_REMATCH[1]}"
        fi
    done
}

function uninstall_redis(){
    version=$1

    # 开机自启
    systemctl stop redis
    systemctl disable redis

    if [ ! -e '/usr/lib/systemd/system/redis.service' ]; then
        echo 'remove /usr/lib/systemd/system/redis.service'
        rm -rf '/usr/lib/systemd/system/redis.service'
    fi

    # 环境变量
    if [ -e '/etc/profile.d/redis.sh' ]; then
        echo 'remove /etc/profile.d/redis.sh'
        rm -rf '/etc/profile.d/redis.sh'
    fi

    # 安装目录
    redis_install_dir=`get_redis_install_dir $version`

    if [ -e $redis_install_dir ]; then
        echo "remove ${redis_install_dir}"
        rm -rf $redis_install_dir
    fi
}