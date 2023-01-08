#!/usr/bin/bash

##################################
# 环境变量
##################################

# 临时目录
QUICK_ENV_TEMP="${QUICK_ENV_HOME}/temp"

if [ ! -e $QUICK_ENV_TEMP ];then
    mkdir $QUICK_ENV_TEMP
fi

# 缓存目录
QUICK_ENV_CACHE="${QUICK_ENV_HOME}/cache"

if [ ! -e $QUICK_ENV_CACHE ];then
    mkdir $QUICK_ENV_CACHE
fi

# 包目录
QUICK_ENV_INCLUDE="${QUICK_ENV_HOME}/include"

# 配置文件目录
QUICK_ENV_CONFIG="${QUICK_ENV_HOME}/config"

# 安装目录
# QUICK_ENV_LOCAL="${QUICK_ENV_HOME}/local"
QUICK_ENV_LOCAL="/opt"
if [ ! -e $QUICK_ENV_LOCAL ];then
    mkdir $QUICK_ENV_LOCAL
fi
