#!/usr/bin/bash

##################################
# 安装 elasticsearch-analysis-ik
##################################

function install_elasticsearch_analysis_ik(){
    # require elasticsearch
    . /etc/profile

    source "${QUICK_ENV_INCLUDE}/install-elasticsearch.sh"
    install_elasticsearch

    # version
    elasticsearch_version="5.6.16"

    install_dir="${ELASTICSEARCH_HOME}/plugins/analysis-ik"

    # install elasticsearch
    plugin_cache_filename="${QUICK_ENV_CACHE}/elasticsearch-analysis-ik-5.6.16.zip"
    plugin_download_url="https://github.com/medcl/elasticsearch-analysis-ik/releases/download/v5.6.16/elasticsearch-analysis-ik-5.6.16.zip"

    if [ ! -e $plugin_cache_filename ]; then
        echo "download elasticsearch-analysis-ik"
        wget $plugin_download_url -O $plugin_cache_filename
    fi

    if [ ! -e $plugin_cache_filename ]; then
        echo "elasticsearch-analysis-ik install error"
        return 0
    fi

    echo "extract elasticsearch-analysis-ik"
    
    # install unzip
    yum install --quiet --assumeyes unzip

    unzip -q $plugin_cache_filename -d "${QUICK_ENV_TEMP}"
    mv -f "${QUICK_ENV_TEMP}/elasticsearch" ${install_dir}
    
    chown -R www:www ${install_dir}

    echo 'elasticsearch-analysis-ik install success'
    echo 'you need restart elasticsearch:'
    echo 'supervisorctl restart elasticsearch'
}