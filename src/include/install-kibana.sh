#!/usr/bin/bash

##################################
# 安装 kibana
# https://mouday.github.io/coding-tree/#/blog/elasticsearch/install
##################################

function install(){
    # check kibana
    . /etc/profile
    if command -v kibana >/dev/null 2>&1; then
        echo 'kibana exists already!'
        return 0
    fi
    
    # require java
    source "${QUICK_ENV_INCLUDE}/install-jdk.sh"
    install

    kibana_version="5.6.16"

    # install elasticsearch
    kibana_cache_filename="${QUICK_ENV_CACHE}/kibana-${kibana_version}-linux-x86_64.tar.gz"
    kibana_download_url="https://repo.huaweicloud.com/kibana/${kibana_version}/kibana-${kibana_version}-linux-x86_64.tar.gz"

    if [ ! -e $kibana_cache_filename ]; then
        echo "download kibana"
        wget $kibana_download_url -O $kibana_cache_filename
    fi

    echo "extract kibana"
    tar -zxf $kibana_cache_filename -C "${QUICK_ENV_LOCAL}"
    # rename
    mv "${QUICK_ENV_LOCAL}/kibana-${kibana_version}-linux-x86_64" "${QUICK_ENV_LOCAL}/kibana-${kibana_version}"

    # env
    cat > /etc/profile.d/kibana.sh <<EOF
# kibana
export KIBANA_HOME="${QUICK_ENV_LOCAL}/kibana-${kibana_version}"
export PATH="\$KIBANA_HOME/bin:\$PATH"
EOF
    source /etc/profile.d/kibana.sh

    # nginx config
    if [[ $NGINX_HOME && -d "${NGINX_HOME}/conf/vhost" ]]; then
        cp "${QUICK_ENV_CONFIG}/nginx-kibana.conf" "${NGINX_HOME}/conf/vhost/kibana.conf"

        nginx -s reload
    fi

    # supervisord config
    if [ -d '/etc/supervisor/conf.d' ]; then
        cat > /etc/supervisor/conf.d/kibana.ini <<EOF
[program:kibana]
directory=${KIBANA_HOME}
command=${KIBANA_HOME}/bin/kibana
user=www
environment=JAVA_HOME=${JAVA_HOME}
EOF
        supervisorctl update
        supervisorctl status
    fi

        # check
        kibana --version

        echo 'kibana install success'
}