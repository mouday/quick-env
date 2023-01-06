#!/usr/bin/bash

##################################
# 安装 elasticsearch-analysis-pinyin
##################################

function install_elasticsearch_analysis_pinyin(){
    # require elasticsearch
    . /etc/profile

    source "${QUICK_ENV_INCLUDE}/install-elasticsearch.sh"
    install_elasticsearch

    # version
    elasticsearch_version="5.6.16"

    plugin_install_dir="${ELASTICSEARCH_HOME}/plugins/analysis-pinyin"

    # install elasticsearch
    plugin_cache_filename="${QUICK_ENV_CACHE}/elasticsearch-analysis-pinyin-5.6.16.zip"
    plugin_download_url="https://github.com/medcl/elasticsearch-analysis-pinyin/releases/download/v5.6.16/elasticsearch-analysis-pinyin-5.6.16.zip"

    if [ ! -e $plugin_cache_filename ]; then
        echo "download elasticsearch-analysis-pinyin"
        wget $plugin_download_url -O $plugin_cache_filename
    fi

    if [ ! -e $plugin_cache_filename ]; then
        echo "elasticsearch-analysis-pinyin install error"
        return 0
    fi

    echo "extract elasticsearch-analysis-pinyin"

    # install unzip
    yum install -y unzip

    unzip -q $plugin_cache_filename -d "${QUICK_ENV_TEMP}"
    mv -f "${QUICK_ENV_TEMP}/elasticsearch" ${plugin_install_dir}

    chown -R www:www ${plugin_install_dir}

    echo 'elasticsearch-analysis-pinyin install success'
    echo 'you need restart elasticsearch:'
    echo 'supervisorctl restart elasticsearch'
}