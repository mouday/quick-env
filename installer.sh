#!/usr/bash

##################################
# quick-env 一键安装器
##################################

export version=0.0.3 && \
yum install -y wget && \
wget https://gitcode.net/mouday/quick-env/-/archive/${version}/quick-env-${version}.tar.gz && \
tar -zxf quick-env-${version}.tar.gz && \
cd quick-env-${version} && \
bash install.sh
