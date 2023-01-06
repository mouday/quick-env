#!/usr/bin/bash

##################################
# 安装 pyenv
##################################

function install_pyenv(){
    # check pyenv
    . /etc/profile
    if command -v pyenv >/dev/null 2>&1; then
        echo 'pyenv exists already!'
        exit 1
    fi

    pyenv_cache_filename="${QUICK_ENV_CACHE}/pyenv-2.3.9-full.tar.gz"
    pyenv_download_url="https://gitee.com/mouday/download/releases/download/upload/pyenv-2.3.9-full.tar.gz"

    # 下载安装
    if [ ! -e $pyenv_cache_filename ]; then
        echo "Download pyenv-2.3.9-full.tar.gz"
        wget $pyenv_download_url -O $pyenv_cache_filename
    fi

    # 解压
    if [ -f $pyenv_cache_filename ]; then
        tar -zxvf $pyenv_cache_filename -C $QUICK_ENV_TEMP
        # rename
        mv "${QUICK_ENV_TEMP}/pyenv-2.3.9-full" "${QUICK_ENV_LOCAL}/pyenv-2.3.9"
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

    # 安装Python编译依赖
    yum install -y gcc make zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel openssl-devel tk-devel libffi-devel xz-devel

    # 生效
    . /etc/profile
    pyenv -v
}


function uninstall_pyenv(){
    
}