#!/usr/bin/bash

##################################
# 安装 quick-env
##################################

# 当前目录
QUICK_ENV_HOME=$( cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
echo $QUICK_ENV_HOME

cat > /etc/profile.d/quick-env.sh <<EOF
# quick-env
export QUICK_ENV_HOME=${QUICK_ENV_HOME}
export PATH=\$QUICK_ENV_HOME/bin:\$PATH
EOF

echo '*************************************'
echo '* quick-env install success'
echo '* source /etc/profile.d/quick-env.sh && qk version'
echo '*************************************'
