#!/usr/bin/bash

##################################
# 安装 elasticsearch
# https://mouday.github.io/coding-tree/#/blog/elasticsearch/install
##################################

function install(){
    # check elasticsearch
    . /etc/profile
    if command -v elasticsearch >/dev/null 2>&1; then
        echo 'elasticsearch exists already!'
        return 0
    fi

    # require java
    source "${QUICK_ENV_INCLUDE}/install-jdk.sh"
    install
    
    # version
    elasticsearch_version="5.6.16"

    # install elasticsearch
    elasticsearch_cache_filename="${QUICK_ENV_CACHE}/elasticsearch-${elasticsearch_version}.tar.gz"
    elasticsearch_download_url="https://repo.huaweicloud.com/elasticsearch/${elasticsearch_version}/elasticsearch-${elasticsearch_version}.tar.gz"

    if [ ! -e $elasticsearch_cache_filename ]; then
        echo "Download elasticsearch"
        wget $elasticsearch_download_url -O $elasticsearch_cache_filename
    fi

    echo "extract elasticsearch"
    tar -zxf $elasticsearch_cache_filename -C "${QUICK_ENV_LOCAL}"

    # env config
    cat > /etc/profile.d/elasticsearch.sh <<EOF
# elasticsearch
export ELASTICSEARCH_HOME="${QUICK_ENV_LOCAL}/elasticsearch-${elasticsearch_version}"
export PATH="\$ELASTICSEARCH_HOME/bin:\$PATH"
EOF
    source /etc/profile.d/elasticsearch.sh

    # nginx config
    if [[ $NGINX_HOME && -d "${NGINX_HOME}/conf/vhost" ]]; then    
        cp "${QUICK_ENV_CONFIG}/nginx-elasticsearch.conf" "${NGINX_HOME}/conf/vhost/elasticsearch.conf"

        nginx -s reload
    fi

    # supervisord config
    if [ -d '/etc/supervisor/conf.d' ]; then
        cat > /etc/supervisor/conf.d/elasticsearch.ini <<EOF
[program:elasticsearch]
directory=${ELASTICSEARCH_HOME}
command=${ELASTICSEARCH_HOME}/bin/elasticsearch
user=www
environment=JAVA_HOME=${JAVA_HOME}
EOF
        supervisorctl update
        supervisorctl status
    fi
    
    # bugfix: main ERROR Could not register mbeans
    # https://pengshiyu.blog.csdn.net/article/details/86557744
    # 创建www用户
    . "${QUICK_ENV_SRC}/utils/create-user-www.sh"
    create_user_www

    chown -R www:www ${ELASTICSEARCH_HOME}

    # install elasticsearch-analysis-pinyin

    # check
    elasticsearch --version

    # elasticsearch-analysis-pinyin
    . "${QUICK_ENV_INCLUDE}/install-elasticsearch-analysis-pinyin.sh"
    install

    # elasticsearch-analysis-ik
    . "${QUICK_ENV_INCLUDE}/install-elasticsearch-analysis-ik.sh"
    install

    echo 'elasticsearch install success'    
}