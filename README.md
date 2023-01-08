# quick-env

- https://github.com/mouday/quick-env/

镜像

- 华为云 https://mirrors.huaweicloud.com/home

运维脚本整合，快速部署运行环境

安装原则

1. 第三方统一安装在`/opt` 目录下
2. 如果遇到多个版本，则按照`软件-版本号`的方式命名
3. 系统级软件一般只安装一个版本，例如nginx；如果安装第二个版本，则按照第二条命名


下载解压

```bash
docker cp ./build/quick-env-full.tar.gz centos7.1:/opt/quick-env-full.tar.gz

docker cp ./ centos7.1:/opt/quick-env-full

# 解压
mkdir -p ./quick-env-full && \
tar -zxf quick-env-full.tar.gz -C ./quick-env-full && \
cd ./quick-env-full

# yum 安装必要的依赖
$ bash main.sh init

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

# 安装1.8.0
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