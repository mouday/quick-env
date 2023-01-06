#!/usr/bin/bash

##################################
# 入口文件
##################################

# 当前文件所在目录
# ref: https://www.jb51.net/article/238524.htm
QUICK_ENV_HOME=$(dirname $(readlink -f "$0"))

# echo $QUICK_ENV_HOME

# 环境变量
source "${QUICK_ENV_HOME}/include/global-evn.sh"

# 入口函数
function main(){
    case $1 in
    "init")
        # 必要的初始化
        source "${QUICK_ENV_INCLUDE}/install-init.sh"
        install_init
        ;;
    "install")
        # 安装
        source "${QUICK_ENV_INCLUDE}/install.sh"
        install $2
        ;;
    "version")
        # 查看版本号
         source "${QUICK_ENV_HOME}/version.sh"
         echo $VERSION
        ;;
    *)
        echo "请输入: help"
        ;;
    esac
}

# command ...args
main $1 $2
