#!/usr/bin/bash

##################################
# 安装 必要工具
##################################

function install_init(){
    # 只允许初始化一次
    init_lock_file="${QUICK_ENV_TEMP}/init-lock.txt"
    if [ -e $init_lock_file ]; then
        echo 'init repeat'
        exit 1
    fi

    # 修改yum源为阿里云源
    source "${QUICK_ENV_INCLUDE}/change-yum-repo.sh"
    change_yum_repo

    # 安装必要依赖
    yum install -y git wget vim

    cat > /etc/profile.d/quick-env.sh <<EOF
# quick-env
alias qk="bash ${QUICK_ENV_HOME}/main.sh"
EOF
    source /etc/profile.d/quick-env.sh
    
    echo '' > $init_lock_file
}
