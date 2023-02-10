#!/usr/bin/bash

##################################
# 安装 openjdk
##################################

function install_openjdk(){
    # check java
    . /etc/profile
    if command -v java >/dev/null 2>&1; then
        echo 'jdk exists already!'
        return 0
    fi

    # install java
    jdk_cache_filename="${QUICK_ENV_CACHE}/jdk-8u351-linux-x64.tar.gz"

    if [ -e $jdk_cache_filename ]; then
        echo "jdk extracting..."
        tar -zxf $jdk_cache_filename -C $QUICK_ENV_LOCAL
        cat > /etc/profile.d/jdk.sh <<EOF
# jkd
export JAVA_HOME="${QUICK_ENV_LOCAL}/jdk1.8.0_351"
export PATH="\$JAVA_HOME/bin:\$PATH"
EOF
        source /etc/profile.d/jdk.sh
    else
        yum install --quiet --assumeyes java-1.8.0-openjdk.x86_64
    fi

    # 验证
    java -version

    echo 'jdk install success'
}