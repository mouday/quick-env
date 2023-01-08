#!/usr/bin/bash

##################################
# 安装 supervisor
# http://supervisord.org/installing.html
# https://pengshiyu.blog.csdn.net/article/details/128494747#51Python_363
##################################

function install(){
    # check supervisorctl
    . /etc/profile
    if command -v supervisorctl >/dev/null 2>&1; then
        echo 'supervisor exists already!'
        return 0
    fi

    # 创建www用户
    . "${QUICK_ENV_SRC}/utils/create-user-www.sh"
    create_user_www

    # supervisor
    # need install pip
    # pip install supervisor

    supervisor_cache_filename="${QUICK_ENV_CACHE}/supervisor-4.2.5-py2.py3-none-any.whl"

    # require pip
    source "${QUICK_ENV_INCLUDE}/install-pip.sh"
    install

    if [ -e $supervisor_cache_filename ]; then
        pip install $supervisor_cache_filename
    else
        pip install supervisor
    fi

    # 生成配置文件目录
    if [ ! -e '/etc/supervisor/conf.d' ]; then
        mkdir -p /etc/supervisor/conf.d
    if

    # override
    cp "${QUICK_ENV_CONFIG}/supervisord.conf" /etc/supervisor/supervisord.conf
    
    # 开机启动
    cp "${QUICK_ENV_HOME}/init.d/supervisord.service" /usr/lib/systemd/system/supervisord.service
    systemctl enable supervisord
    systemctl start supervisord

    supervisorctl status

    echo 'supervisor install success'
}