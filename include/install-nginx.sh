#!/usr/bin/bash

##################################
# 安装 nginx
##################################

function install_nginx(){
    # check nginx
    . /etc/profile
    if command -v nginx >/dev/null 2>&1; then
        echo 'nginx exists already!'
        return 0
    fi
    
    version="1.8.0"

    nginx_cache_filename="${QUICK_ENV_CACHE}/nginx-${version}.tar.gz"
    nginx_source_dir="${QUICK_ENV_CACHE}/nginx-${version}"
    nginx_install_dir="${QUICK_ENV_LOCAL}/nginx"
    nginx_download_url="http://nginx.org/download/nginx-${version}.tar.gz"

    if [ -e  $nginx_install_dir ]; then
        echo "nginx install dir exists: ${nginx_install_dir}"
        return 0
    fi

    # install nginx
    # 1、安装编译工具
    yum -y install make zlib zlib-devel gcc gcc-c++ libtool  openssl openssl-devel pcre pcre-devel ncurses-devel perl

    # 2、创建用户
    source "${QUICK_ENV_INCLUDE}/create-user-www.sh"
    create_user_www

    # 下载nginx
    if [ ! -e $nginx_cache_filename ]; then
        echo "Download nginx"
        wget $nginx_download_url -O $nginx_cache_filename
    fi

    # 解压
    if [ -e $nginx_cache_filename ]; then
        tar -zxf $nginx_cache_filename
    else
        echo "nginx cache file not exists!"
        exit 1
    fi

    cd $nginx_source_dir

    echo 'nginx installing'

    ./configure \
    --prefix=${nginx_install_dir} \
    --user=${run_user} \
    --group=${run_group} \
    --with-http_stub_status_module \
    --with-http_ssl_module \
    --with-http_gzip_static_module \
    --with-pcre \
    --with-http_realip_module \
    --with-http_sub_module \
    --quiet

    make && make install

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
ExecStartPost=/bin/sleep 0.1
ExecStartPre=${nginx_install_dir}/sbin/nginx -t -c ${nginx_install_dir}/conf/nginx.conf
ExecStart=${nginx_install_dir}/sbin/nginx -c ${nginx_install_dir}/conf/nginx.conf
ExecReload=/bin/kill -s HUP \$MAINPID
ExecStop=/bin/kill -s QUIT \$MAINPID
TimeoutStartSec=120
LimitNOFILE=1000000
LimitNPROC=1000000
LimitCORE=1000000

[Install]
WantedBy=multi-user.target
EOF
    fi

    # 修改配置文件
    mv "${nginx_install_dir}/conf/nginx.conf" "${nginx_install_dir}/conf/nginx.conf.bak"
    cp "${QUICK_ENV_CONFIG}/nginx.conf" "${nginx_install_dir}/conf/nginx.conf"
    
    mkdir -p "${nginx_install_dir}/conf/vhost"

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