#!/usr/bin/bash

##################################
# 安装命令入口
##################################

# 安装命令
function install(){
    arg=$1

    # 拆分字符串参数为数组 
    # python@3.7.0 => ('python' '3.7.0')
    arr=(`echo $arg | tr '@' ' '`)

    # 如果数组长度为2，则取第二个参数为版本号
    if [ ${#arr[@]} -eq 2 ]; then
        name=${arr[0]}
        version=${arr[1]}
    else
        name=$arg
        version=''
    fi

    case $name in
    "pyenv")
        source "${QUICK_ENV_HOME}/include/install-pyenv.sh"
        install_pyenv
        ;;
    "python-use-pyenv")
        source "${QUICK_ENV_HOME}/include/install-python-use-pyenv.sh"
        install_python_use_pyenv
        ;;
    "python")
        source "${QUICK_ENV_HOME}/include/install-python.sh"
        install_python $version
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
    "elasticsearch-analysis-ik")
        source "${QUICK_ENV_INCLUDE}/install-elasticsearch-analysis-ik.sh"
        install_elasticsearch_analysis_ik
        ;;
    "elasticsearch-analysis-pinyin")
        source "${QUICK_ENV_INCLUDE}/install-elasticsearch-analysis-pinyin.sh"
        install_elasticsearch_analysis_pinyin
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