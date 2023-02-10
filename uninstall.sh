#!/usr/bin/bash

##################################
# 卸载 quick-env
##################################

# 移除变量
if [ -e /etc/profile.d/quick-env.sh ]; then 
    rm -rf /etc/profile.d/quick-env.sh
fi

echo '*************************************'
echo '* quick-env uninstall success'
echo '*************************************'