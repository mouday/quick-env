#!/usr/bin/bash

##################################
# 安装 elasticsearch
# https://mouday.github.io/coding-tree/#/blog/elasticsearch/install
##################################

function install_elasticsearch(){
    # check elasticsearch
    . /etc/profile
    if command -v elasticsearch >/dev/null 2>&1; then
        echo 'elasticsearch exists already!'
        return 0
    fi
    
    # install elasticsearch
    elasticsearch_cache_filename="${QUICK_ENV_CACHE}/elasticsearch-5.6.16.tar.gz"
    elasticsearch_download_url="https://repo.huaweicloud.com/elasticsearch/5.6.16/elasticsearch-5.6.16.tar.gz"

    if [ ! -e $elasticsearch_cache_filename ]; then
        echo "Download elasticsearch"
        wget $elasticsearch_download_url -O $elasticsearch_cache_filename
    fi

    echo "extract elasticsearch"
    tar -zxf $elasticsearch_cache_filename -C "${QUICK_ENV_LOCAL}"

    # env config
    cat > /etc/profile.d/elasticsearch.sh <<EOF
# elasticsearch
export ELASTICSEARCH_HOME="${QUICK_ENV_LOCAL}/elasticsearch-5.6.16"
export PATH="\$ELASTICSEARCH_HOME/bin:\$PATH"
EOF
    source /etc/profile.d/elasticsearch.sh

    # nginx config
    if [[ ! $NGINX_HOME && -d "${NGINX_HOME}/conf/vhost" ]]; then    
        cp "${QUICK_ENV_CONFIG}/nginx-elasticsearch.conf" "${NGINX_HOME}/conf/vhost/elasticsearch.conf"
    fi

    # supervisord config
    cat > /etc/supervisor/conf.d/elasticsearch.ini <<EOF
[program:elasticsearch]
directory=${ELASTICSEARCH_HOME}
command=${ELASTICSEARCH_HOME}/bin/elasticsearch
user=www
EOF
        
        # check
        elasticsearch --version

        echo 'elasticsearch install success'
}