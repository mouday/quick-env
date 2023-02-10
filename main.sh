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
. "${QUICK_ENV_HOME}/global-evn.sh"

# 入口函数
function main(){
    action=$1
    name=$2
    version=''

    # 拆分字符串参数为数组
    # python-3.7.0 => ('python' '3.7.0')
    arr=(`echo $name | tr '-' ' '`)

    # 如果数组长度为2，则取第二个参数为版本号
    if [ ${#arr[@]} -eq 2 ]; then
        name=${arr[0]}
        version=${arr[1]}
    fi

    # echo "${action} ${name} ${version}"
    
    . "${QUICK_ENV_HOME}/utils/array-utils.sh"
    
    
    if [ ! $action ]; then
        action="x"
    fi

    # 特殊指令
    if [ $(in_array "install,uninstall,download,use" $action) == "true" ]; then
        if [ ! $name ]; then
            echo "eg: ${action} [name]"
            return 1
        fi

        action_file="${QUICK_ENV_INCLUDE}/${name}.sh"
        if [ -e $action_file ]; then
            . $action_file
            action_main $action $version
        else
            echo "${action_file} not found"
        fi
        
    else
        case $action in
        # "init")
        #     # 必要的初始化
        #     source "${QUICK_ENV_SRC}/utils/install-init.sh"
        #     install_init
        #     ;;
        # "install")
        #     install_filename="${QUICK_ENV_INCLUDE}/install-${name}.sh"
        #     echo $install_filename

        #     if [ -e $install_filename ]; then
        #         # 安装
        #         . $install_filename
        #         eval "install_${name}" $version
        #     else
        #         # 安装提示
        #         . "${QUICK_ENV_HOME}/utils/echo-install-names.sh"
        #         echo_install_names
        #     fi
        #     ;;
        # "uninstall")
        #     install_filename="${QUICK_ENV_INCLUDE}/install-${name}.sh"
        #     echo $install_filename

        #     if [ -e $install_filename ]; then
        #         . $install_filename
        #         eval "uninstall_${name}" $version
        #     else
        #         # 安装提示
        #         . "${QUICK_ENV_HOME}/src/utils/echo-install-names.sh"
        #         echo_install_names
        #     fi
        #     ;;
        "version")
            # 查看版本号
            source "${QUICK_ENV_HOME}/version.sh"
            echo "quick env version: $VERSION"
            ;;
        "help")
            echo "wecome use quick env!"
            echo "eg:"
            echo "$ qk install nginx-1.22.1"
            echo "more info please see: https://github.com/mouday/quick-env"
            ;;
        *)
            echo "help"
            ;;
        esac
    fi
}

# command ...args
main $@
