#!/usr/bin/bash

##################################
# 安装 python
##################################

function install_python(){

    # install pyenv
    . /etc/profile
    if ! command -v pyenv >/dev/null 2>&1; then
        source "${QUICK_ENV_INCLUDE}/install-pyenv.sh"
        install_pyenv
    fi

    version='3.7.0'

    python_cache_filename="${QUICK_ENV_CACHE}/Python-${version}.tar.xz"
    python_pyenv_cache_filename="${PYENV_ROOT}/cache/Python-${version}.tar.xz"
    python_download_url="https://mirrors.huaweicloud.com/python/${version}/Python-${version}.tar.xz"

    # download
    if [ ! -e $python_pyenv_cache_filename ]; then
        if [ ! -e $python_cache_filename ]; then
            echo "Download Python-${version}.tar.xz"
            wget $python_download_url -O $python_cache_filename
        fi
        cp $python_cache_filename $python_pyenv_cache_filename
    fi

    # use pyenv install python
    . /etc/profile
    pyenv install "${version}"
    
    # check
    pyenv shell "${version}"
    python --version
}