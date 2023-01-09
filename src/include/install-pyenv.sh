#!/usr/bin/bash

##################################
# 安装 pyenv
##################################

function install_pyenv(){
    # check pyenv
    . /etc/profile
    if command -v pyenv >/dev/null 2>&1; then
        echo 'pyenv already installed!'
        return 0
    fi
    
    # config
    pyenv_cache_file="${QUICK_ENV_CACHE}/pyenv-2.3.9-full.tar.gz"
    pyenv_download_url="https://gitee.com/mouday/download/releases/download/upload/pyenv-2.3.9-full.tar.gz"

    # 下载安装
    if [ ! -e $pyenv_cache_file ]; then
        echo "Download pyenv-2.3.9-full.tar.gz"
        wget $pyenv_download_url -O $pyenv_cache_file
    fi

    # 解压
    if [ -f $pyenv_cache_file ]; then
        tar -zxf $pyenv_cache_file
        # rename
        mv "${QUICK_ENV_CACHE}/pyenv-2.3.9-full" "${QUICK_ENV_LOCAL}/pyenv"
    else
        exit 1
    fi
    
    # Custom profile
    # cp profile.d/pyenv.sh /etc/profile.d/pyenv.sh
        cat > /etc/profile.d/pyenv.sh <<EOF
# pyenv
export PYENV_ROOT="${QUICK_ENV_LOCAL}/pyenv-2.3.9"
export PATH="\$PYENV_ROOT/bin:\$PATH"
eval "\$(pyenv init -)"
eval "\$(pyenv virtualenv-init -)"
EOF

    # 生效
    . /etc/profile
    pyenv -v
}


function uninstall_pyenv(){
    
}