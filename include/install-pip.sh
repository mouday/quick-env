#!/usr/bin/bash

##################################
# 安装 pip
# https://pengshiyu.blog.csdn.net/article/details/128492350
##################################

function install_pip(){
    # check pip
    . /etc/profile
    if command -v pip >/dev/null 2>&1; then
        echo 'pip exists already!'
        return 0
    fi
    
    # install pip
    pip_cache_filename="${QUICK_ENV_CACHE}/get-pip.py"
    pip_download_url="https://bootstrap.pypa.io/pip/2.7/get-pip.py"

    # download
    if [ ! -e $pip_cache_filename ]; then
        # Python2.7
        wget $pip_download_url -O $pip_cache_filename
    fi
   
    # 安装
    python ${pip_cache_filename}

    # 设置下载源
    pip config set global.index-url https://pypi.douban.com/simple/
    pip config set install.trusted-host pypi.douban.com

    # 检查
    pip -V
}