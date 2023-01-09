#!/usr/bin/bash

##################################
# 入口文件
##################################

# 当前文件所在目录
# ref: https://www.jb51.net/article/238524.htm
# QUICK_ENV_HOME=$(dirname $(readlink -f "$0"))

# ref: https://www.cnblogs.com/zsg88/p/16732429.html
QUICK_ENV_HOME=$( cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# echo $QUICK_ENV_HOME

# 全局环境变量
. "${QUICK_ENV_HOME}/src/global-evn.sh"

# 入口函数
function main(){
    action=$1
    name=$2

    case $action in
    "init")
        # 必要的初始化
        source "${QUICK_ENV_SRC}/utils/install-init.sh"
        install_init
        ;;
    "install")
        # 拆分字符串参数为数组
        # python-3.7.0 => ('python' '3.7.0')
        arr=(`echo $name | tr '-' ' '`)

        # 如果数组长度为2，则取第二个参数为版本号
        if [ ${#arr[@]} -eq 2 ]; then
            name=${arr[0]}
            version=${arr[1]}
        else
            name=$name
            version=''
        fi

        echo "${name} ${version}"

        install_filename="${QUICK_ENV_INCLUDE}/install-${name}.sh"
        echo $install_filename

        if [ -e $install_filename ]; then
            # 安装
            . $install_filename
            eval "install_${name}" $version
        else
            # 安装提示
            . "${QUICK_ENV_HOME}/src/utils/echo-install-names.sh"
            echo_install_names
        fi
        ;;
    "uninstall")
        # 拆分字符串参数为数组
        # python-3.7.0 => ('python' '3.7.0')
        arr=(`echo $name | tr '-' ' '`)

        # 如果数组长度为2，则取第二个参数为版本号
        if [ ${#arr[@]} -eq 2 ]; then
            name=${arr[0]}
            version=${arr[1]}
        else
            name=$name
            version=''
        fi

        echo "${name} ${version}"

        install_filename="${QUICK_ENV_INCLUDE}/install-${name}.sh"
        echo $install_filename

        if [ -e $install_filename ]; then
            . $install_filename
            eval "uninstall_${name}" $version
        else
            # 安装提示
            . "${QUICK_ENV_HOME}/src/utils/echo-install-names.sh"
            echo_install_names
        fi
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
