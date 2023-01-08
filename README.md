# quick-env

- https://github.com/mouday/quick-env/

镜像

- 华为云 https://mirrors.huaweicloud.com/home

运维脚本整合，快速部署运行环境

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
$ qk install python3

# 安装python2.7 pip
$ qk install pip

# 安装1.8.0
$ qk install nginx

# 安装4.2.5
$ qk install supervisor

# 安装8u351
$ qk install jdk

# 安装5.6.16
$ qk install elasticsearch

# 安装5.6.16
$ qk install kibana

# elasticsearch-analysis-ik
$ qk install elasticsearch-analysis-ik

# elasticsearch-analysis-pinyin
$ qk install elasticsearch-analysis-pinyin
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
