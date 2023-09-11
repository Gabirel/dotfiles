#!/usr/bin/env bash
# Only works under Debian/Ubuntu

#fonts color
Green="\033[32m"
Red="\033[31m"
# Yellow="\033[33m"
GreenBG="\033[42;37m"
RedBG="\033[41;37m"
NC="\033[0m"

#notification information
# Info="${Green}[信息]${NC}"
OK="${Green}[OK]${NC}"
Error="${Red}[错误]${NC}"

set_timezone() {
    # timezone: Shanghai
    timedatectl set-timezone Asia/Shanghai
}

# configure for server environment
pre_install() {
    apt update -y

    # 1. install all needed tools
    apt install socat cron nginx fish vim git wget curl htop tree iperf3 rsync jq unzip -y

    # 2. change default to fish
    chsh -s /usr/bin/fish
}

install_trace() {
    # 1. download nexttrace
    nexttrace_dump="/tmp/besttrace"
    wget https://github.com/nxtrace/NTrace-V1/releases/latest/download/nexttrace_linux_amd64 -O $nexttrace_dump
    if [ $? -ne 0 ]; then
        echo -e "${RedBG}>>> Failed to download nexttrace!${NC}"
        exit 1
    fi

    chmod +x $nexttrace_dump
    ln -f $nexttrace_dump /usr/local/bin/nexttrace

    # 2. download worsttrace 
    wget https://wtrace.app/packages/linux/worsttrace -O /tmp/worsttrace
    if [ $? -ne 0 ]; then
        echo -e "${RedBG}>>> Failed to download worsttrace scripts!${NC}"
        exit 1
    fi
    chmod +x /tmp/worsttrace
    ln -f /tmp/worsttrace /usr/local/bin/worsttrace
}

# install xray related
install_xray() {
    # 1. install xray using official scripts
    bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install

    # 2. enable service
    systemctl enable --now xray nginx
}

install_acme() {
    systemctl stop nginx

    domain=$1

    # 1. download acme scripts
    wget https://raw.githubusercontent.com/Gabirel/dotfiles/master/scripts/proxy/acme_install.sh
    if [ $? -ne 0 ]; then
        echo -e "${RedBG}>>> Failed to download acme scripts!${NC}"
        exit 1
    fi

    # 2. chmod +x
    chmod +x acme_install.sh

    # start acme_install
    bash ./acme_install.sh $domain
    if [ $? -ne 0 ]; then
        echo -e "${RedBG}>>> Failed to issue certificat with acme!${NC}"
        exit 1
    fi
}

install_crontab() {
    domain=$1

    # 1. download ssl_update
    wget https://raw.githubusercontent.com/Gabirel/dotfiles/master/scripts/proxy/ssl_update.sh
    if [ $? -ne 0 ]; then
        echo -e "${RedBG}>>> Failed to download ssl_update scripts!${NC}"
        exit 1
    fi

    # 2. download update-v2raydat
    wget https://raw.githubusercontent.com/Gabirel/dotfiles/master/scripts/proxy/update-v2raydat-vps.sh
    if [ $? -ne 0 ]; then
        echo -e "${RedBG}>>> Failed to download update_v2raydat scripts!${NC}"
        exit 1
    fi

    # 2. chmod +x
    chmod +x ssl_update.sh update-v2raydat-vps.sh

    # 3. link crontab task
    ln -f ssl_update.sh /usr/local/bin/ssl_update
    ln -f update-v2raydat-vps.sh /usr/local/bin/update-v2raydat-vps

    # 4. write to crontabs
    crontab_path='/var/spool/cron/crontabs/root'
    echo "0 3 * * * /usr/local/bin/ssl_update $domain >/dev/null 2>&1" >> $crontab_path
    echo "9 3 * * * /usr/local/bin/update-v2raydat-vps >/dev/null 2>&1" >> $crontab_path
}

config_xray() {
    # 1. generate new uuid
    uuid=`xray uuid`
    echo -e "${OK} ${GreenBG} uuid: $uuid ${NC}"

    # 2. download template json using base64
    template_json="ewogICJsb2ciOiB7CiAgICAiYWNjZXNzIjogIi92YXIvbG9nL3hyYXkvYWNjZXNzLmxvZyIsCiAgICAiZXJyb3IiOiAiL3Zhci9sb2cveHJheS9lcnJvci5sb2ciLAogICAgImxvZ2xldmVsIjogIndhcm5pbmciCiAgfSwKICAiaW5ib3VuZHMiOiBbCiAgICB7CiAgICAgICJzbmlmZmluZyI6IHsKICAgICAgICAiZW5hYmxlZCI6IHRydWUsCiAgICAgICAgImRlc3RPdmVycmlkZSI6IFsKICAgICAgICAgICJodHRwIiwKICAgICAgICAgICJ0bHMiCiAgICAgICAgXQogICAgICB9LAogICAgICAicG9ydCI6IDQ0MywKICAgICAgInByb3RvY29sIjogInZsZXNzIiwKICAgICAgInNldHRpbmdzIjogewogICAgICAgICJjbGllbnRzIjogWwogICAgICAgICAgewogICAgICAgICAgICAiaWQiOiAieHh4LXh4eC14eHgiLAogICAgICAgICAgICAiZmxvdyI6ICJ4dGxzLXJwcngtdmlzaW9uIiwKICAgICAgICAgICAgImxldmVsIjogMCwKICAgICAgICAgICAgImVtYWlsIjogImxvdmVAdjJmbHkub3JnIgogICAgICAgICAgfQogICAgICAgIF0sCiAgICAgICAgImRlY3J5cHRpb24iOiAibm9uZSIsCiAgICAgICAgImZhbGxiYWNrcyI6IFsKICAgICAgICAgIHsKICAgICAgICAgICAgImRlc3QiOiAiODAwMSIsCiAgICAgICAgICAgICJ4dmVyIjogMQogICAgICAgICAgfSwKICAgICAgICAgIHsKICAgICAgICAgICAgImFscG4iOiAiaDIiLAogICAgICAgICAgICAiZGVzdCI6ICI4MDAyIiwKICAgICAgICAgICAgInh2ZXIiOiAxCiAgICAgICAgICB9CiAgICAgICAgXQogICAgICB9LAogICAgICAic3RyZWFtU2V0dGluZ3MiOiB7CiAgICAgICAgIm5ldHdvcmsiOiAidGNwIiwKICAgICAgICAic2VjdXJpdHkiOiAidGxzIiwKICAgICAgICAidGxzU2V0dGluZ3MiOiB7CiAgICAgICAgICAicmVqZWN0VW5rbm93blNuaSI6IHRydWUsCiAgICAgICAgICAibWluVmVyc2lvbiI6ICIxLjMiLAogICAgICAgICAgImFscG4iOiBbCiAgICAgICAgICAgICJoMiIsCiAgICAgICAgICAgICJodHRwLzEuMSIKICAgICAgICAgIF0sCiAgICAgICAgICAiY2VydGlmaWNhdGVzIjogWwogICAgICAgICAgICB7CiAgICAgICAgICAgICAgImNlcnRpZmljYXRlRmlsZSI6ICIvZGF0YS92MnJheS5jcnQiLAogICAgICAgICAgICAgICJrZXlGaWxlIjogIi9kYXRhL3YycmF5LmtleSIKICAgICAgICAgICAgfQogICAgICAgICAgXQogICAgICAgIH0KICAgICAgfQogICAgfQogIF0sCiAgIm91dGJvdW5kcyI6IFsKICAgIHsKICAgICAgInByb3RvY29sIjogImZyZWVkb20iLAogICAgICAic2V0dGluZ3MiOiB7CgogICAgICB9LAogICAgICAidGFnIjogImZyZWVkb20iCiAgICB9LAogICAgewogICAgICAicHJvdG9jb2wiOiAiYmxhY2tob2xlIiwKICAgICAgInNldHRpbmdzIjogewoKICAgICAgfSwKICAgICAgInRhZyI6ICJibG9jayIKICAgIH0KICBdLAogICJkbnMiOiB7CiAgICAic2VydmVycyI6IFsKICAgICAgIjEuMS4xLjEiCiAgICBdLAogICAgInF1ZXJ5U3RyYXRlZ3kiOiAiVXNlSVB2NCIKICB9LAogICJyb3V0aW5nIjogewogICAgImRvbWFpblN0cmF0ZWd5IjogIklQSWZOb25NYXRjaCIsCiAgICAicnVsZXMiOiBbCiAgICAgIHsKICAgICAgICAidHlwZSI6ICJmaWVsZCIsCiAgICAgICAgIm91dGJvdW5kVGFnIjogImJsb2NrIiwKICAgICAgICAicHJvdG9jb2wiOiBbCiAgICAgICAgICAiYml0dG9ycmVudCIKICAgICAgICBdCiAgICAgIH0sCiAgICAgIHsKICAgICAgICAidHlwZSI6ICJmaWVsZCIsCiAgICAgICAgImlwIjogWwogICAgICAgICAgIjEuMS4xLjEiCiAgICAgICAgXSwKICAgICAgICAib3V0Ym91bmRUYWciOiAiZnJlZWRvbSIKICAgICAgfSwKICAgICAgewogICAgICAgICJ0eXBlIjogImZpZWxkIiwKICAgICAgICAiZG9tYWluIjogWwogICAgICAgICAgImdlb3NpdGU6Z29vZ2xlIgogICAgICAgIF0sCiAgICAgICAgIm91dGJvdW5kVGFnIjogImZyZWVkb20iCiAgICAgIH0sCiAgICAgIHsKICAgICAgICAidHlwZSI6ICJmaWVsZCIsCiAgICAgICAgImRvbWFpbiI6IFsKICAgICAgICAgICJnZW9zaXRlOmNhdGVnb3J5LWFkcy1hbGwiLAogICAgICAgICAgImdlb3NpdGU6Y24iCiAgICAgICAgXSwKICAgICAgICAib3V0Ym91bmRUYWciOiAiYmxvY2siCiAgICAgIH0sCiAgICAgIHsKICAgICAgICAidHlwZSI6ICJmaWVsZCIsCiAgICAgICAgImlwIjogWwogICAgICAgICAgImdlb2lwOmNuIiwKICAgICAgICAgICJnZW9pcDpwcml2YXRlIgogICAgICAgIF0sCiAgICAgICAgIm91dGJvdW5kVGFnIjogImJsb2NrIgogICAgICB9CiAgICBdCiAgfQp9"
    echo $template_json| base64 --decode > template.json

    # 3. replace new uuid
    jq --arg variable "$uuid" '.inbounds[].settings.clients[].id = $variable' template.json > /usr/local/etc/xray/config.json
}

config_nginx() {
    # 1. backup original nginx config
    mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak

    # 2. download nginx config
    wget https://raw.githubusercontent.com/Gabirel/dotfiles/master/data/config/nginx/nginx.conf -O /etc/nginx/nginx.conf
    if [ $? -ne 0 ]; then
        echo -e "${RedBG}>>> Failed to download nginx conf!${NC}"
        exit 1
    fi
    echo -e "${OK} ${GreenBG} nginx配置文件下载完成"
}

post_install() {
    # 1. update geo file
    update-v2raydat-vps

    # 2. restart xray nginx
    systemctl restart xray nginx

    # 3. clean up
    rm -rf ./template.json
}

bbr_install() {
    echo "net.core.default_qdisc = fq" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_congestion_control = bbr" >> /etc/sysctl.conf
    sysctl -p
}

echo_xray_uuid() {
    current_config_xray='/usr/local/etc/xray/config.json'
    uuid=`jq -r '.inbounds[].settings.clients[].id' $current_config_xray`
    echo -e "${OK} ${GreenBG} Your uuid: $uuid ${NC}"
}

# domain must be set
if [[ $# -ne 1 ]]; then
    echo -e "${RedBG}>>> domain must be set!${NC}"
    exit 1
fi
domain=$1

set_timezone
echo -e "${OK} ${GreenBG} 时区修改完成${NC}"

pre_install
echo -e "${OK} ${GreenBG} 环境预安装完成${NC}"

install_trace
echo -e "${OK} ${GreenBG} 安装Trace工具(besttrace & worsttrace)完成${NC}"

install_xray
echo -e "${OK} ${GreenBG} xray安装完成${NC}"

config_xray
echo -e "${OK} ${GreenBG} xray配置完成${NC}"

config_nginx
echo -e "${OK} ${GreenBG} nginx配置完成${NC}"

install_acme $domain
echo -e "${OK} ${GreenBG} acme安装完成${NC}"

install_crontab $domain
echo -e "${OK} ${GreenBG} crontab安装完成${NC}"

post_install
echo -e "${OK} ${GreenBG} post安装完成${NC}"

bbr_install
echo -e "${OK} ${GreenBG} BBR + FQ 安装完成${NC}"

echo_xray_uuid
