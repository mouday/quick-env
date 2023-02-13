#!/usr/bash

##################################
# 安装 nginx
# http://nginx.org/en/download.html
# ref https://pengshiyu.blog.csdn.net/article/details/103023669
##################################

DEFAULT_VERSION='1.22.1' # 19 Oct 2022

function download() {
    version=$1
    # echo "download ${version}"

    download_url="http://nginx.org/download/nginx-${version}.tar.gz"
    cache_filename="${QUICK_ENV_CACHE}/nginx-${version}.tar.gz"

    # download
    if [ ! -e $cache_filename ]; then
        echo "downloading: ${download_url}"
        yum install -y wget 1>/dev/null
        wget $download_url -O $cache_filename
    else
        echo "use cache: ${cache_filename}"
    fi
}

function uninstall() {
    local version=$1
    local install_dir="${QUICK_ENV_LOCAL}/nginx-${version}"

    if [ -e  $install_dir ]; then
        rm -rf $install_dir
    fi
}

function use() {
    local version=$1

    local install_dir="${QUICK_ENV_LOCAL}/nginx-${version}"

    # 软链
    cat > /etc/profile.d/nginx.sh <<EOF
# nginx
export NGINX_HOME=${install_dir}
export PATH="\$NGINX_HOME/sbin:\$PATH"
EOF

    # 开机自启
    cat > /usr/lib/systemd/system/nginx.service <<EOF
[Unit]
Description=nginx - high performance web server
Documentation=http://nginx.org/en/docs/
After=network.target

[Service]
Type=forking
PIDFile=${install_dir}/logs/nginx.pid
ExecStartPre=${install_dir}/sbin/nginx -t -c ${install_dir}/conf/nginx.conf
ExecStart=${install_dir}/sbin/nginx -c ${install_dir}/conf/nginx.conf
ExecReload=${install_dir}/sbin/nginx -s reload
ExecStop=/bin/kill -s QUIT \$MAINPID
PrivateTmp=true

[Install]
WantedBy=multi-user.target
EOF

    systemctl enable nginx
    systemctl restart nginx

    # 查看版本
    . /etc/profile.d/nginx.sh
    nginx -v

    echo '*************************************'
    echo '* nginx use success'
    echo '* source /etc/profile.d/nginx.sh && nginx -v'
    echo '* systemctl status nginx'
    echo '*************************************'
}

function install(){
    version=$1

    cache_filename="${QUICK_ENV_CACHE}/nginx-${version}.tar.gz"
    source_dir="${QUICK_ENV_CACHE}/nginx-${version}"
    install_dir="${QUICK_ENV_LOCAL}/nginx-${version}"

    if [ -e  $install_dir ]; then
        echo "nginx install dir exists: ${install_dir}"
        return 0
    fi

    # 1、安装编译工具
    echo 'install dependencies'
    yum -y install make wget zlib zlib-devel gcc gcc-c++ libtool openssl openssl-devel pcre pcre-devel ncurses-devel perl 1>/dev/null
    
    if [ $? != 0 ]; then
        echo 'nginx install dependencies error'
        exit 1
    fi

    # 下载
    download $version

    # 解压
    if [ ! -e $cache_filename ]; then
        echo "nginx cache file not exists!"
        exit 1
    fi

    tar -zxf $cache_filename -C $QUICK_ENV_CACHE

    # 安装
    if [ ! -e $source_dir ]; then
        echo "nginx source not exists!"
        exit 1
    fi

    echo 'nginx installing'
    cd $source_dir

    ./configure \
    --prefix=${install_dir} \
    --with-http_stub_status_module \
    --with-http_ssl_module \
    --with-http_gzip_static_module \
    --with-pcre \
    --with-http_realip_module \
    --with-http_sub_module \
    1>/dev/null
    
    if [ $? != 0 ]; then
        echo 'nginx configure error'
        exit 1
    fi

    make 1>/dev/null && make install 1>/dev/null
    
    if [ $? != 0 ]; then
        echo 'nginx make error'
        exit 1
    fi

    # 返回
    cd -
    
    use $version    
}
