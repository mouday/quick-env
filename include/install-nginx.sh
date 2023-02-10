#!/usr/bash

##################################
# 安装 nginx
# http://nginx.org/en/download.html
# ref https://pengshiyu.blog.csdn.net/article/details/103023669
##################################

function install_nginx(){
    version=$1

    if [ ! $version ]; then
        version='1.22.1' # 19 Oct 2022
    fi

    # check nginx
    . /etc/profile
    if command -v nginx >/dev/null 2>&1; then
        echo 'nginx exists already!'
        return 0
    fi

    nginx_cache_filename="${QUICK_ENV_CACHE}/nginx-${version}.tar.gz"
    nginx_source_dir="${QUICK_ENV_CACHE}/nginx-${version}"
    nginx_install_dir="${QUICK_ENV_LOCAL}/nginx-${version}"
    nginx_download_url="http://nginx.org/download/nginx-${version}.tar.gz"

    if [ -e  $nginx_install_dir ]; then
        echo "nginx install dir exists: ${nginx_install_dir}"
        return 0
    fi

    # 1、安装编译工具
    echo 'install dependencies'
    yum -y install make wget zlib zlib-devel gcc gcc-c++ libtool openssl openssl-devel pcre pcre-devel ncurses-devel perl 1>/dev/null
    
    if [ $? != 0 ]; then
        echo 'nginx install dependencies error'
        exit 1
    fi

    # 2、创建用户
    # . "${QUICK_ENV_SRC}/utils/create-user-www.sh"
    # create_user_www

    # 下载nginx
    if [ ! -e $nginx_cache_filename ]; then
        echo "Download nginx"
        wget $nginx_download_url -O $nginx_cache_filename
    else
        echo 'using nginx cache file'
    fi

    # 解压
    if [ ! -e $nginx_cache_filename ]; then
        echo "nginx cache file not exists!"
        exit 1
    fi

    tar -zxf $nginx_cache_filename -C $QUICK_ENV_CACHE

    # 安装
    if [ ! -e $nginx_source_dir ]; then
        echo "nginx source not exists!"
        exit 1
    fi

    echo 'nginx installing'
    cd $nginx_source_dir

    ./configure \
    --prefix=${nginx_install_dir} \
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

    # 软链
    # ln -s "${QUICK_ENV_HOME}/local/nginx/1.8.0/sbin/nginx" /usr/local/bin/nginx
    if [ ! -e '/etc/profile.d/nginx.sh' ]; then
        cat > /etc/profile.d/nginx.sh <<EOF
# nginx
export NGINX_HOME=${nginx_install_dir}
export PATH="\$NGINX_HOME/sbin:\$PATH"
EOF
    fi

    # 开机自启
    # cp "${QUICK_ENV_HOME}/init.d/nginx.service" /usr/lib/systemd/system/nginx.service
    if [ ! -e '/usr/lib/systemd/system/nginx.service' ]; then
        cat > /usr/lib/systemd/system/nginx.service <<EOF
[Unit]
Description=nginx - high performance web server
Documentation=http://nginx.org/en/docs/
After=network.target

[Service]
Type=forking
PIDFile=${nginx_install_dir}/logs/nginx.pid
ExecStartPre=${nginx_install_dir}/sbin/nginx -t -c ${nginx_install_dir}/conf/nginx.conf
ExecStart=${nginx_install_dir}/sbin/nginx -c ${nginx_install_dir}/conf/nginx.conf
ExecReload=${nginx_install_dir}/sbin/nginx -s reload
ExecStop=/bin/kill -s QUIT \$MAINPID
PrivateTmp=true

[Install]
WantedBy=multi-user.target
EOF
    fi

    # 修改配置文件
    # mv "${nginx_install_dir}/conf/nginx.conf" "${nginx_install_dir}/conf/nginx.conf.bak"
    # cp "${QUICK_ENV_CONFIG}/nginx.conf" "${nginx_install_dir}/conf/nginx.conf"
    
    # mkdir -p "${nginx_install_dir}/conf/vhost"

    systemctl enable nginx
    systemctl start nginx

    # 查看版本
    . /etc/profile.d/nginx.sh
    nginx -v

    echo '*************************************'
    echo '* nginx install success'
    echo '* source /etc/profile.d/nginx.sh'
    echo '* systemctl status nginx'
    echo '*************************************'
}