# quick-env

Linux 缺失的软件包的管理器，运维脚本整合，快速部署运行环境

- https://github.com/mouday/quick-env/
- https://gitee.com/mouday/quick-env/
- https://gitcode.net/mouday/quick-env

## 安装

安装最新版本

```bash
# github源
curl https://raw.githubusercontent.com/mouday/quick-env/master/installer.sh | bash

# 镜像
curl https://ghproxy.com/https://raw.githubusercontent.com/mouday/quick-env/master/installer.sh | bash
```

安装指定版本

```bash
# Github源
export version=0.0.3 && \
yum install -y wget && \
wget https://github.com/mouday/quick-env/archive/refs/tags/${version}.tar.gz -O quick-env-${version}.tar.gz && \
tar -zxf quick-env-${version}.tar.gz && \
cd quick-env-${version} && \
bash install.sh
```

手动下载安装

```bash
# 解压
tar -zxf quick-env-0.0.3.tar.gz && \
cd ./quick-env-0.0.3

# yum 安装必要的依赖
$ bash install.sh
```

安装原则

1. 第三方统一默认安装在`/opt` 目录下
2. 按照`软件-版本号`的方式命名，以便安装多个版本

## 使用

```bash
# 首次运行
source /etc/profile.d/quick-env.sh

# 查看版本号
$ qk version

# 安装2.3.9
$ qk install pyenv

# 安装3.7.0
$ qk install python
$ qk install python-3.6.5

# 安装python2.7 pip
$ qk install pip

# 安装nginx
$ qk install nginx

# 安装4.2.5
$ qk install supervisor

# 安装8u351
$ qk install jdk

# 安装5.6.16，默认包含以下两个插件
$ qk install elasticsearch

# elasticsearch-analysis-ik
$ qk install elasticsearch-analysis-ik

# elasticsearch-analysis-pinyin
$ qk install elasticsearch-analysis-pinyin

# 安装5.6.16
$ qk install kibana

# 安装16.9.0
$ qk install nodejs
$ qk install nodejs-16.9.1
```

## 管理进程

系统进程

```bash
# supervisord
systemctl status supervisord

# nginx
systemctl status nginx
```

应用进程

```bash
# elasticsearch
supervisorctl status elasticsearch

# kibana
supervisorctl status kibana
```

> 部分源码参考: https://oneinstack.com/

# 自定义安装

如需自定义安装路径，可在`global-evn.sh` 中修改参数

```bash
# 安装目录
QUICK_ENV_LOCAL="/opt"
```

## 测试

docker启动centos7

```bash
docker run \
--privileged \
-itd \
--name env \
-v /sys/fs/cgroup:/sys/fs/cgroup:ro \
centos:centos7 /usr/sbin/init && \
docker exec -it env /bin/bash

make build && docker cp ./build/quick-env-0.0.1.tar.gz nginx:/opt

docker cp ./ env:/opt/quick-env-0.0.1/

tar -zxf quick-env-0.0.1.tar.gz

docker cp ./src/ nginx:/opt/quick-env-0.0.1/

docker cp ./build/quick-env-full.tar.gz centos7.1:/opt/quick-env-full.tar.gz

docker cp ./src centos7.1:/opt/quick-env-full/

```

镜像

- 华为云 https://mirrors.huaweicloud.com/home
