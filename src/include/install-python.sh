#!/usr/bin/bash

##################################
# 安装 python3
# eg: qk install python  // default: 3.7.0
# eg: qk install python-3.6.5
##################################

function install_python(){
    version=$1

    if [ ! $version ]; then
        version='3.7.0'
    fi

    # check python3
    # . /etc/profile
    # if command -v python3 >/dev/null 2>&1; then
    #     echo 'python3 exists already!'
    #     return 0
    # fi

    # Python-3.7.0.tar.xz
    python_cache_filename="${QUICK_ENV_CACHE}/Python-${version}.tar.xz"
    python_source_dir="${QUICK_ENV_CACHE}/Python-${version}"

    # 应该考虑安装多个版本
    python_install_dir="${QUICK_ENV_LOCAL}/python-${version}"
    # https://mirrors.huaweicloud.com/python/
    python_download_url="https://mirrors.huaweicloud.com/python/${version}/Python-${version}.tar.xz"

    # 如果目录被占用就不再继续
    if [ -e  $python_install_dir ]; then
        echo "python3 install dir exists: ${python_install_dir}"
        return 0
    fi

    # download
    if [ ! -e $python_cache_filename ]; then
        echo "Download Python-${version}.tar.xz"
        wget $python_download_url -O $python_cache_filename

        if [ "$?" -ne 0 ]; then
            echo "Download Python error"
            return 1
        fi
    fi

    # 解压
    if [ -e $python_cache_filename ]; then
        # mkdir -p $python_source_dir
        tar -xJf $python_cache_filename -C $QUICK_ENV_CACHE
    else
        echo "python cache file not exists!"
        exit 1
    fi

    # 安装Python编译依赖
    yum install --quiet --assumeyes gcc make zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel openssl-devel tk-devel libffi-devel xz-devel

    if [ "$?" -ne 0 ]; then
        echo "yum install error"
        return 1
    fi

    # install python
    echo "install python@${version}"
    if [ ! -e $python_source_dir ]; then
        echo "python3 source dir not exists!"
        return 1
    fi

    cd $python_source_dir

    ./configure --prefix=${python_install_dir} --quiet && \
    make >/dev/null 2>&1 && \
    make install >/dev/null 2>&1

    if [ "$?" -ne 0 ]; then
        echo "python install error"
        return 1
    fi

    cd -

    # 环境变量
    if [ ! -e '/etc/profile.d/python.sh' ]; then
        cat > /etc/profile.d/python.sh <<EOF
# python
export PYTHON_HOME=${python_install_dir}
export PATH="\$PYTHON_HOME/bin:\$PATH"
EOF
    fi

    # # 做软链
    # if [ ! -e '/usr/local/bin/python3' ]; then
    #     ln -s "${python_install_dir}/bin/python3" /usr/local/bin/python3
    # fi
    
    # if [ ! -e '/usr/local/bin/pip3' ]; then
    #     ln -s "${python_install_dir}/bin/pip3" /usr/local/bin/pip3
    # fi

    echo '*************************************'
    echo "* python@${version} install success"
    echo "* ${python_install_dir}/bin/python3"
    echo '* source /etc/profile.d/python.sh && python3 --version'
    echo '*************************************'
}