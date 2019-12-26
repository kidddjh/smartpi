#!/bin/bash


blue(){
    echo -e "\033[34m\033[01m$1\033[0m"
}
green(){
    echo -e "\033[32m\033[01m$1\033[0m"
}
red(){
    echo -e "\033[31m\033[01m$1\033[0m"
}
yellow(){
    echo -e "\033[33m\033[01m$1\033[0m"
}
bred(){
    echo -e "\033[31m\033[01m\033[05m$1\033[0m"
}
byellow(){
    echo -e "\033[33m\033[01m\033[05m$1\033[0m"
}


function install_smartpi(){
apt-get -y update
apt -y install wget unzip zip curl
wget https://github.com/pymumu/smartdns/releases/download/Release28/smartdns.1.2019.12.15-1028.x86_64-linux-all.tar.gz
tar zxf smartdns.1.2019.12.15-1028.x86_64-linux-all.tar.gz
cd smartdns
chmod +x ./install
./install -i
rm -rf /etc/smartdns/smartdns.conf
cat > /etc/smartdns/smartdns.conf <<-EOF
bind [::]:5599

cache-size 512

prefetch-domain yes

rr-ttl 300
rr-ttl-min 60
rr-ttl-max 86400

log-level info
log-file /var/log/smartdns.log
log-size 128k
log-num 2

server 202.141.162.123
server 202.141.176.93
server-tcp 202.141.162.123
server-tcp 202.141.176.93
server-tcp 114.114.114.114
server-tls 8.8.8.8
server-tls 8.8.4.4

EOF

cp /etc/smartdns/smartdns.conf /etc/smartdns/smartdns.conf.bak

systemctl enable smartdns
systemctl start smartdns

curl -sSL https://install.pi-hole.net | bash

sed -i '/PIHOLE_DNS/d' /etc/pihole/setupVars.conf
sed -i '$a PIHOLE_DNS_1=127.0.0.1#5599' /etc/pihole/setupVars.conf

pihole restartdns

	green " ========================================================================="
	green " SmartPi安装完成"
    green " 系统：>=debian9"
    green " Youtube：米月"
    green " 电报群：https://t.me/mi_yue"
    green " Youtube频道地址：https://www.youtube.com/channel/UCr4HCEgaZ0cN5_7tLHS_xAg"
	green " ========================================================================="
	
}

function update_smartdns(){
if test -s /etc/smartdns/smartdns.conf.bak; then
	rm -rf /etc/smartdns/smartdns.conf.bak
	cp /etc/smartdns/smartdns.conf /etc/smartdns/smartdns.conf.bak
	./install -u
	rm -rf /root/smartdns*
fi
wget https://github.com/pymumu/smartdns/releases/download/Release28/smartdns.1.2019.12.15-1028.x86_64-linux-all.tar.gz
tar zxf smartdns.1.2019.12.15-1028.x86_64-linux-all.tar.gz
cd smartdns
chmod +x ./install
./install -i
if test -s /etc/smartdns/smartdns.conf.bak; then
	rm -rf /etc/smartdns/smartdns.conf
	cp /etc/smartdns/smartdns.conf.bak /etc/smartdns/smartdns.conf
fi
systemctl enable smartdns
systemctl restart smartdns
pihole restartdns
	green " ========================================================================="
	green " SmartPi更新完成"
    green " 系统：>=debian9"
    green " Youtube：米月"
    green " 电报群：https://t.me/mi_yue"
    green " Youtube频道地址：https://www.youtube.com/channel/UCr4HCEgaZ0cN5_7tLHS_xAg"
	green " ========================================================================="
}

function m_pass(){
    red " =================================="
    red " 修改pi-hole密码"
    red " =================================="
    pihole -a -p
    red " =================================="
    red " pi-hole密码修改完成"
    red " =================================="
}

function rebuil_pi-hole(){
    green " ================================"
    green " 开始重新安装pi-hole"
    green " ================================"
    pihole -r
    green " ================================"
    green " pi-hole安装完成"
    green " ================================"
}

start_menu(){
    clear
    green " ========================================================================"
    green " 简介：debian一键安装SmartPi"
    green " 系统：>=debian9"
    green " Youtube：米月"
    green " 电报群：https://t.me/mi_yue"
    green " Youtube频道地址：https://www.youtube.com/channel/UCr4HCEgaZ0cN5_7tLHS_xAg"
    green " ========================================================================"
    echo
    green  " 1. 一键安装SmartPi"
	green  " 2. 一键更新SmartPi"
	green  " 3. 重新安装pi-hole"
	green  " 4. 更改pi-hole密码"
    yellow " 0. 退出脚本"
    echo
    read -p " 请输入数字:" num
    case "$num" in
    1)
    install_smartpi
    ;;
    2)
    update_smartdns
    ;;
	3)
    rebuil_pi-hole 
    ;;
	4)
    m_pass 
    ;;
    0)
    exit 1
    ;;
    *)
    clear
    red "输入的数字不正确，请重新输入"
    sleep 1s
    start_menu
    ;;
    esac
}

start_menu
