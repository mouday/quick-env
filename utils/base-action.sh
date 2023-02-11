#!/usr/bash

##################################
# 基类
##################################

DEFAULT_VERSION='xxx'

function download() {
    echo "download"
}

function uninstall() {
    echo "uninstall"
}

function use() {
    echo "use"
}

function install(){
    echo "install"  
}

function action_help(){
    echo "action_help"  
}

# 入口
function action_main(){
    local action=$1
    local version=$2
    
    if [ ! $version ]; then
        version=$DEFAULT_VERSION
    fi

    # echo "action ${action} ${version}"

    case $action in
    "install")
        install $version
        ;;
    "uninstall")
        uninstall $version
        ;;
    "use")
        use $version
        ;;
    "download")
        download $version
        ;;
    *)
        action_help $version
        ;;
    esac
}