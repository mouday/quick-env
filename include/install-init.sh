#!/usr/bin/bash

##################################
# 安装 必要工具
##################################

function install_init(){
    # 只允许初始化一次
    init_lock_file="${QUICK_ENV_HOME}/init-lock.txt"
    if [ -e $init_lock_file ]; then
        echo 'init repeat'
        exit 1
    fi

    # 创建web目录
    wwwroot_dir='/data/wwwroot'
    wwwlogs_dir='/data/wwwlogs'
    wwwbackup_dir='/data/wwwbackup'
    
    if [ ! -e $wwwroot_dir ]; then
        mkdir -p $wwwroot_dir
    fi

    if [ ! -e $wwwlogs_dir ]; then
        mkdir -p $wwwlogs_dir
    fi

    if [ ! -e $wwwbackup_dir ]; then
        mkdir -p $wwwbackup_dir
    fi
    
    # 修改yum源为阿里云源
    . "${QUICK_ENV_INCLUDE}/change-yum-repo.sh"
    change_yum_repo

    # 修改pip源

    # 安装必要依赖
    yum install --quiet --assumeyes git wget vim

    cat > /etc/profile.d/quick-env.sh <<EOF
# quick-env
alias qk="bash ${QUICK_ENV_HOME}/main.sh"
EOF

    # lock
    echo '' > $init_lock_file

    echo '*************************************'
    echo '* quick-env install success'
    echo '* source /etc/profile.d/quick-env.sh && qk version'
    echo '*************************************'
}
