#!/usr/bin/bash

##################################
# install nodejs
##################################

function install() {
    version=$1

    if [ ! $version ]; then
        version='16.9.0'
    fi

    nodejs_cache_filename="${QUICK_ENV_CACHE}/node-v${version}-linux-x64.tar.xz"
    nodejs_source_dir="${QUICK_ENV_CACHE}/node-v${version}-linux-x64"
    nodejs_install_dir="${QUICK_ENV_LOCAL}/nodejs-${version}"
    nodejs_download_url="https://repo.huaweicloud.com/nodejs/v${version}/node-v${version}-linux-x64.tar.xz"

    # 如果目录被占用就不再继续
    if [ -e  $nodejs_install_dir ]; then
        echo "nodejs install dir exists: ${nodejs_install_dir}"
        return 0
    fi

    # download
    if [ ! -e $nodejs_cache_filename ]; then
        echo "Download nodejs-${version}.tar.xz"
        wget $nodejs_download_url -O $nodejs_cache_filename
    fi

    # 解压
    if [ ! -e $nodejs_cache_filename ]; then
        echo "cache file not exists!"
        exit 1        
    fi

    tar -xJf $nodejs_cache_filename -C $QUICK_ENV_CACHE
    mv $nodejs_source_dir $nodejs_install_dir

    if [ ! -e "/etc/profile.d/nodejs.sh" ]; then
      cat > /etc/profile.d/nodejs.sh << EOF
export NODE_HOME=${nodejs_install_dir}
export PATH=\$NODE_HOME/bin:\$PATH
EOF
    fi

    echo '*************************************'
    echo "* nodejs@${version} install success"
    echo '* source /etc/profile.d/nodejs.sh && node --version'
    echo '*************************************'
}