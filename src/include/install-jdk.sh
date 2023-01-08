#!/usr/bin/bash

##################################
# 安装 jdk
# （1）TUNA镜像
# https://mirrors.tuna.tsinghua.edu.cn/Adoptium/

# （2）HUAWEI镜像
# https://repo.huaweicloud.com/java/jdk/ 

# （3）injdk
# https://www.injdk.cn/
##################################

function install(){
    # check java
    . /etc/profile
    if command -v java >/dev/null 2>&1; then
        echo 'jdk exists already!'
        return 0
    fi

    # install java
    jdk_cache_filename="${QUICK_ENV_CACHE}/jdk-8u351-linux-x64.tar.gz"
    
    # https://mirrors.tuna.tsinghua.edu.cn/Adoptium/8/jdk/x64/linux/OpenJDK8U-jdk_x64_linux_hotspot_8u352b08.tar.gz
    # https://d6.injdk.cn/openjdk/openjdk/8/openjdk-8u41-src-b04-14_jan_2020.zip
    jdk_download_url='https://repo.huaweicloud.com/java/jdk/8u202-b08/jdk-8u202-linux-x64.tar.gz'

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