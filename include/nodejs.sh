#!/usr/bash

##################################
# install nodejs
##################################

DEFAULT_VERSION='19.6.0' # 03-Feb-2023 00:13

# 下载
function download() {
    version=$1
    # echo "download ${version}"

    download_url="https://repo.huaweicloud.com/nodejs/v${version}/node-v${version}-linux-x64.tar.xz"
    cache_filename="${QUICK_ENV_CACHE}/node-v${version}-linux-x64.tar.xz"

    # download
    if [ ! -e $cache_filename ]; then
        echo "downloading: ${download_url}"
        yum install -y wget 1>/dev/null
        wget $download_url -O $cache_filename
    else
        echo "use cache: ${cache_filename}"
    fi
}

# 安装
function install() {
    version=$1

    cache_filename="${QUICK_ENV_CACHE}/node-v${version}-linux-x64.tar.xz"
    source_dir="${QUICK_ENV_CACHE}/node-v${version}-linux-x64"
    install_dir="${QUICK_ENV_LOCAL}/nodejs-${version}"
    
    # 如果目录被占用就不再继续
    if [ -e  $install_dir ]; then
        echo "nodejs install dir exists: ${install_dir}"
        return 0
    fi

    # download
    download $version

    if [ ! -e $cache_filename ]; then
        echo "${cache_filename} not found"
        exit 1
    fi
    
    # extract
    tar -xJf $cache_filename -C $QUICK_ENV_CACHE && \
    mv $source_dir $install_dir && \
    use $version
}

# 卸载
function uninstall() {
    local version=$1

    install_dir="${QUICK_ENV_LOCAL}/nodejs-${version}"

    if [ -e  $install_dir ]; then
        rm -rf $install_dir
    fi

    if [ -e '/etc/profile.d/nodejs.sh' ]; then
        rm -rf /etc/profile.d/nodejs.sh
    fi

    echo "uninstall nodejs successful"
}

# 版本切换
function use() {
    local version=$1
    
    install_dir="${QUICK_ENV_LOCAL}/nodejs-${version}"

    if [ ! -e $install_dir ]; then
        echo "nodejs-${version} not install"
        return 1
    fi

    cat > /etc/profile.d/nodejs.sh << EOF
export NODE_HOME=${install_dir}
export PATH=\$NODE_HOME/bin:\$PATH
EOF

    echo '*************************************'
    echo "* use nodejs@${version}"
    echo '* source /etc/profile.d/nodejs.sh && node --version'
    echo '*************************************'
}
