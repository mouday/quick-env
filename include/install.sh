#!/usr/bin/bash

##################################
# 安装命令入口
##################################

# 安装命令
function install(){
    case $1 in
    "pyenv")
        source "${QUICK_ENV_HOME}/include/install-pyenv.sh"
        install_pyenv
        ;;
    "python")
        source "${QUICK_ENV_HOME}/include/install-python.sh"
        install_python
        ;;
    "pip")
        source "${QUICK_ENV_INCLUDE}/install-pip.sh"
        install_pip
        ;;
    "nginx")
        source "${QUICK_ENV_HOME}/include/install-nginx.sh"
        install_nginx
        ;;
    "supervisor")
        source "${QUICK_ENV_HOME}/include/install-supervisor.sh"
        install_supervisor
        ;;
    "jdk")
        source "${QUICK_ENV_INCLUDE}/install-jdk.sh"
        install_jdk
        ;;
    "elasticsearch")
        source "${QUICK_ENV_INCLUDE}/install-elasticsearch.sh"
        install_elasticsearch
        ;;
    "kibana")
        source "${QUICK_ENV_INCLUDE}/install-kibana.sh"
        install_kibana
        ;;
    *)
        echo "install [name]"
        echo "pyenv"
        echo "python"
        echo "pip"
        echo "nginx"
        echo "supervisor"
        echo "jdk"
        echo "elasticsearch"
        echo "kibana"
        ;;
    esac
}