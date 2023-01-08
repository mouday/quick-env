#!/usr/bin/bash

##################################
# 创建用户 www
##################################

function create_user_www(){
    # 创建用户
    # groupadd www
    # useradd -g www www -M -s /sbin/nologin
    # -M参数表示不添加用户家目录，-s参数表示指定shell类型
    run_group='www'
    run_user='www'

    id -g ${run_group} >/dev/null 2>&1
    [ $? -ne 0 ] && groupadd ${run_group}
    id -u ${run_user} >/dev/null 2>&1
    [ $? -ne 0 ] && useradd -g ${run_group} -M -s /sbin/nologin ${run_user}

}