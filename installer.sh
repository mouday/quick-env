#!/usr/bash

##################################
# quick-env 一键安装器
##################################

# wget https://gitcode.net/mouday/quick-env/-/archive/${version}/quick-env-${version}.tar.gz && \
# wget https://github.com/mouday/quick-env/archive/refs/tags/${version}.tar.gz -O quick-env-${version}.tar.gz

export version=0.0.6 && \
yum install -y wget && \
wget https://ghproxy.com/https://github.com/mouday/quick-env/archive/refs/tags/${version}.tar.gz -O quick-env-${version}.tar.gz && \
tar -zxf quick-env-${version}.tar.gz && \
cd quick-env-${version} && \
bash install.sh
