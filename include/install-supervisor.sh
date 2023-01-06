#!/usr/bin/bash

##################################
# 安装 supervisor
# http://supervisord.org/installing.html
# https://pengshiyu.blog.csdn.net/article/details/128494747#51Python_363
##################################

function install_supervisor(){
    # install pyenv
    . /etc/profile
    if command -v supervisorctl >/dev/null 2>&1; then
        echo 'supervisor exists already!'
        return 0
    fi

    # 创建www用户
    source "${QUICK_ENV_INCLUDE}/create-user-www.sh"
    create_user_www

    # supervisor
    # need install pip
    # pip install supervisor

    supervisor_cache_filename="${QUICK_ENV_CACHE}/supervisor-4.2.5-py2.py3-none-any.whl"

    # require pip 
    source "${QUICK_ENV_INCLUDE}/install-pip.sh"
    install_pip

    if [ -e $supervisor_cache_filename ]; then
        pip install $supervisor_cache_filename
    else
        pip install supervisor
    fi

    # supervisor_cache_filename="${QUICK_ENV_CACHE}/supervisor-4.2.5.tar.gz"
    # supervisor_download_url="https://files.pythonhosted.org/packages/ce/37/517989b05849dd6eaa76c148f24517544704895830a50289cbbf53c7efb9/supervisor-4.2.5.tar.gz"
    
    # # 下载安装
    # if [ ! -e $supervisor_cache_filename ]; then
    #     echo "Download supervisor"
    #     wget $supervisor_download_url -O $supervisor_cache_filename
    # fi

    # # 解压
    # if [ -f $supervisor_cache_filename ]; then
    #     tar -zxvf $supervisor_cache_filename -C $QUICK_ENV_TEMP
    # else
    #     exit 1
    # fi

    # # install
    # cd "${QUICK_ENV_TEMP}/supervisor-4.2.5"
    
    # need setuptools
    # python setup.py install

    # 生成配置文件目录
    mkdir -p /etc/supervisor/conf.d
    cp "${QUICK_ENV_CONFIG}/supervisord.conf" /etc/supervisor/supervisord.conf
    
    # 开机启动
    cp "${QUICK_ENV_HOME}/init.d/supervisord.service" /usr/lib/systemd/system/supervisord.service
    systemctl enable supervisord
    systemctl start supervisord

    supervisorctl status

    echo 'supervisor install success'
}