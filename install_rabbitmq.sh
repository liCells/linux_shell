#!/bin/bash

yum -y update
yum -y install epel-release
cd ~
# 下载 && 安装 -> erlang
echo "releases page: https://github.com/rabbitmq/rabbitmq-server/releases"
read -p "download erlang rpm url:" erlangRpmUrl
if [ x${erlangRpmUrl} = "x" ]
then
    wget -c https://packages.erlang-solutions.com/erlang/rpm/centos/7/x86_64/esl-erlang_24.0.2-1~centos~7_amd64.rpm
else
    wget -c $erlangRpmUrl
fi
yum install -y esl-erlang*

echo "releases page: https://github.com/rabbitmq/rabbitmq-server/releases"
echo "default url: https://github.com/rabbitmq/rabbitmq-server/releases/download/v3.9.7/rabbitmq-server-3.9.7-1.el7.noarch.rpm"
read -p "download rabbitmq rpm url:" rabbitRpmUrl
# 下载 && 安装 -> rabbitmq
if [ x$rabbitRpmUrl = "x" ]
then
    wget -c https://github.com/rabbitmq/rabbitmq-server/releases/download/v3.9.7/rabbitmq-server-3.9.7-1.el7.noarch.rpm
else
    wget -c $rabbitRpmUrl
fi
sudo yum install -y rabbitmq-server*
# 启动 && 设置开机自启 -> rabbit服务
systemctl start rabbitmq-server.service
systemctl enable rabbitmq-server.service

read -p "Is the firewall port released? [Y, default N]" released
if [ $released = "y" || $released = "Y" ]
    # 设置对应防火墙端口 [4369,25672,5671,5672,15672,61613,61614,1883,8883]
    firewall-cmd --zone=public --permanent --add-port=4369/tcp --add-port=25672/tcp --add-port=5671-5672/tcp --add-port=15672/tcp  --add-port=61613-61614/tcp --add-port=1883/tcp --add-port=8883/tcp
    firewall-cmd --reload
fi