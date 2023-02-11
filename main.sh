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
    version=$3

    # echo "${action} ${name} ${version}"
    
    . "${QUICK_ENV_HOME}/utils/array-utils.sh"
    if [ $(in_array "install,uninstall,download,use,help" $action) == "true" ]; then
        if [ ! $name ]; then
            echo "eg: ${action} [name]"
            return 1
        fi

        . "${QUICK_ENV_HOME}/utils/base-action.sh"
        action_file="${QUICK_ENV_INCLUDE}/${name}.sh"
        if [ -e $action_file ]; then
            . $action_file
            action_main $action $version
        else
            echo "${action_file} not found"
        fi
        
    else
        case $action in
        "version")
            # 查看版本号
            source "${QUICK_ENV_HOME}/version.sh"
            echo "quick env version: $VERSION"
            ;;
        *)
            echo "wecome use quick env!"
            echo "$ qk [action] [name] <version>"
            echo "eg:"
            echo "$ qk install nginx 1.22.1"
            echo "more info please see: https://github.com/mouday/quick-env"
            ;;
        esac
    fi
}

# command ...args
main $@
