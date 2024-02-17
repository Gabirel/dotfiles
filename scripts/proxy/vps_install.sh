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
    apt install socat cron fish vim git wget curl htop tree iperf3 rsync jq unzip -y

    # 2. change default to fish
    chsh -s /usr/bin/fish
}

# install latest nginx
install_nginx() {
    # 1. install all needed tools
    apt install -y gnupg2 ca-certificates lsb-release debian-archive-keyring \
        && curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor > /usr/share/keyrings/nginx-archive-keyring.gpg \
        && echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] http://nginx.org/packages/mainline/debian `lsb_release -cs` nginx" > /etc/apt/sources.list.d/nginx.list \
        && echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" > /etc/apt/preferences.d/99nginx \
        && apt update -y && apt install -y nginx \
        && mkdir -p /etc/systemd/system/nginx.service.d \
        && echo -e "[Service]\nExecStartPost=/bin/sleep 0.1" > /etc/systemd/system/nginx.service.d/override.conf \
        && systemctl daemon-reload
}

install_trace() {
    # 1. download nexttrace
    nexttrace_dump="/tmp/nexttrace"
    wget https://github.com/nxtrace/NTrace-V1/releases/latest/download/nexttrace_linux_amd64 -O $nexttrace_dump
    if [ $? -ne 0 ]; then
        echo -e "${RedBG}>>> Failed to download nexttrace!${NC}"
        exit 1
    fi

    chmod +x $nexttrace_dump
    ln -f $nexttrace_dump /usr/local/bin/nexttrace
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
        echo -e "${RedBG}>>> Failed to issue certificate with acme!${NC}"
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
    domain=$1

    # 1. generate new uuid, as well as other stuff
    uuid=$(xray uuid)
    echo -e "${OK} ${GreenBG} uuid: $uuid ${NC}"

    full_x25519_key=$(xray x25519)
    private_key=$(echo $full_x25519_key | cut -d ' ' -f 3)
    export public_key=$(echo $full_x25519_key | cut -d ' ' -f 6)
    echo -e "${OK} ${GreenBG} private key: $private_key ${NC}"
    echo -e "${OK} ${GreenBG} public key: $public_key ${NC}"
    export short_id=$(openssl rand -hex 8)
    echo -e "${OK} ${GreenBG} short id: $short_id ${NC}"

    # 2. download template json using base64
    template_json="ewogICJsb2ciOiB7CiAgICAiYWNjZXNzIjogIi92YXIvbG9nL3hyYXkvYWNjZXNzLmxvZyIsCiAgICAiZXJyb3IiOiAiL3Zhci9sb2cveHJheS9lcnJvci5sb2ciLAogICAgImxvZ2xldmVsIjogIndhcm5pbmciCiAgfSwKICAiaW5ib3VuZHMiOiBbCiAgICB7CiAgICAgICJzbmlmZmluZyI6IHsKICAgICAgICAiZW5hYmxlZCI6IHRydWUsCiAgICAgICAgImRlc3RPdmVycmlkZSI6IFsKICAgICAgICAgICJodHRwIiwKICAgICAgICAgICJ0bHMiCiAgICAgICAgXQogICAgICB9LAogICAgICAicG9ydCI6IDQ0MywKICAgICAgInByb3RvY29sIjogInZsZXNzIiwKICAgICAgInNldHRpbmdzIjogewogICAgICAgICJjbGllbnRzIjogWwogICAgICAgICAgewogICAgICAgICAgICAiaWQiOiAieHh4LXh4eC14eHgiLAogICAgICAgICAgICAiZmxvdyI6ICJ4dGxzLXJwcngtdmlzaW9uIiwKICAgICAgICAgICAgImxldmVsIjogMCwKICAgICAgICAgICAgImVtYWlsIjogImxvdmVAdjJmbHkub3JnIgogICAgICAgICAgfQogICAgICAgIF0sCiAgICAgICAgImRlY3J5cHRpb24iOiAibm9uZSIKICAgICAgfSwKICAgICAgInN0cmVhbVNldHRpbmdzIjogewogICAgICAgICJuZXR3b3JrIjogInRjcCIsCiAgICAgICAgInNlY3VyaXR5IjogInJlYWxpdHkiLAogICAgICAgICJyZWFsaXR5U2V0dGluZ3MiOiB7CiAgICAgICAgICAic2hvdyI6IGZhbHNlLAogICAgICAgICAgImRlc3QiOiAiODAwMSIsCiAgICAgICAgICAieHZlciI6IDEsCiAgICAgICAgICAic2VydmVyTmFtZXMiOiBbCiAgICAgICAgICAgICJ4eHgueHh4IgogICAgICAgICAgXSwKICAgICAgICAgICJwcml2YXRlS2V5IjogInh4eHh4LXh4eHh4LXh4eHh4IiwKICAgICAgICAgICJzaG9ydElkcyI6IFsKICAgICAgICAgICAgIjEyMzQ1Njc4IgogICAgICAgICAgXSwKICAgICAgICAgICJmaW5nZXJwcmludCI6ICJjaHJvbWUiCiAgICAgICAgfQogICAgICB9CiAgICB9CiAgXSwKICAib3V0Ym91bmRzIjogWwogICAgewogICAgICAicHJvdG9jb2wiOiAiZnJlZWRvbSIsCiAgICAgICJzZXR0aW5ncyI6IHt9LAogICAgICAidGFnIjogImZyZWVkb20iCiAgICB9LAogICAgewogICAgICAicHJvdG9jb2wiOiAiYmxhY2tob2xlIiwKICAgICAgInNldHRpbmdzIjoge30sCiAgICAgICJ0YWciOiAiYmxvY2siCiAgICB9CiAgXSwKICAiZG5zIjogewogICAgInNlcnZlcnMiOiBbCiAgICAgICIxLjEuMS4xIgogICAgXSwKICAgICJxdWVyeVN0cmF0ZWd5IjogIlVzZUlQdjQiCiAgfSwKICAicm91dGluZyI6IHsKICAgICJkb21haW5TdHJhdGVneSI6ICJJUElmTm9uTWF0Y2giLAogICAgInJ1bGVzIjogWwogICAgICB7CiAgICAgICAgInR5cGUiOiAiZmllbGQiLAogICAgICAgICJvdXRib3VuZFRhZyI6ICJibG9jayIsCiAgICAgICAgInByb3RvY29sIjogWwogICAgICAgICAgImJpdHRvcnJlbnQiCiAgICAgICAgXQogICAgICB9LAogICAgICB7CiAgICAgICAgInR5cGUiOiAiZmllbGQiLAogICAgICAgICJpcCI6IFsKICAgICAgICAgICIxLjEuMS4xIgogICAgICAgIF0sCiAgICAgICAgIm91dGJvdW5kVGFnIjogImZyZWVkb20iCiAgICAgIH0sCiAgICAgIHsKICAgICAgICAidHlwZSI6ICJmaWVsZCIsCiAgICAgICAgImRvbWFpbiI6IFsKICAgICAgICAgICJnZW9zaXRlOmdvb2dsZSIKICAgICAgICBdLAogICAgICAgICJvdXRib3VuZFRhZyI6ICJmcmVlZG9tIgogICAgICB9LAogICAgICB7CiAgICAgICAgInR5cGUiOiAiZmllbGQiLAogICAgICAgICJkb21haW4iOiBbCiAgICAgICAgICAiZ2Vvc2l0ZTpjYXRlZ29yeS1hZHMtYWxsIiwKICAgICAgICAgICJnZW9zaXRlOmNuIgogICAgICAgIF0sCiAgICAgICAgIm91dGJvdW5kVGFnIjogImJsb2NrIgogICAgICB9LAogICAgICB7CiAgICAgICAgInR5cGUiOiAiZmllbGQiLAogICAgICAgICJpcCI6IFsKICAgICAgICAgICJnZW9pcDpjbiIsCiAgICAgICAgICAiZ2VvaXA6cHJpdmF0ZSIKICAgICAgICBdLAogICAgICAgICJvdXRib3VuZFRhZyI6ICJibG9jayIKICAgICAgfQogICAgXQogIH0KfQ=="
    echo $template_json| base64 --decode > template.json

    # 3. replace new uuid
    jq --arg variable "$uuid" '.inbounds[].settings.clients[].id = $variable' template.json > template2.json
    jq --arg variable  "$private_key" '.inbounds[0].streamSettings.realitySettings.privateKey = $variable' template2.json > template3.json
    jq --arg variable "$short_id" '.inbounds[0].streamSettings.realitySettings.shortIds[0] = $variable' template3.json > template4.json
    jq --arg variable "$domain" '.inbounds[0].streamSettings.realitySettings.serverNames[0] = $variable' template4.json > /usr/local/etc/xray/config.json
  
    echo -e "${OK} ${GreenBG} xray config 配置完成"
}

config_nginx() {
    domain=$1
    nginx_conf="/etc/nginx/nginx.conf"
    # 1. backup original nginx config
    mv $nginx_conf /etc/nginx/nginx.conf.bak

    # 2. download nginx config
    wget https://raw.githubusercontent.com/Gabirel/dotfiles/master/data/config/nginx/nginx.conf -O /etc/nginx/nginx.conf
    if [ $? -ne 0 ]; then
        echo -e "${RedBG}>>> Failed to download nginx conf!${NC}"
        exit 1
    fi
    echo -e "${OK} ${GreenBG} nginx配置文件下载完成"

    # 3. config domain to nginx file
    sed -i "s/\${server_name}/$domain/g" $nginx_conf
    if [ $? -ne 0 ]; then
        echo -e "${RedBG}>>> Failed to config nginx conf domain!${NC}"
        exit 1
    fi
    echo -e "${OK} ${GreenBG} nginx域名配置完成"
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

echo_xray_config() {
    current_config_xray='/usr/local/etc/xray/config.json'
    uuid=$(jq -r '.inbounds[].settings.clients[].id' $current_config_xray)
    echo -e "${OK} ${GreenBG} uuid: $uuid ${NC}"
    
    echo -e "${OK} ${GreenBG} public key: $public_key ${NC}"
    echo -e "${OK} ${GreenBG} short id: $short_id ${NC}"
}

# domain must be set
if [[ $# -ne 1 ]]; then
    echo -e "${RedBG}>>> domain must be set!${NC}"
    exit 1
fi
domain=$1
public_key=""
short_id=""

set_timezone
echo -e "${OK} ${GreenBG} 时区修改完成${NC}"

pre_install
echo -e "${OK} ${GreenBG} 环境预安装完成${NC}"

install_nginx
echo -e "${OK} ${GreenBG} nginx最新版安装完成${NC}"

install_trace
echo -e "${OK} ${GreenBG} 安装Trace工具(nexttrace)完成${NC}"

install_xray
echo -e "${OK} ${GreenBG} xray安装完成${NC}"

config_xray $domain
echo -e "${OK} ${GreenBG} xray配置完成${NC}"

config_nginx $domain
echo -e "${OK} ${GreenBG} nginx配置完成${NC}"

install_acme $domain
echo -e "${OK} ${GreenBG} acme安装完成${NC}"

install_crontab $domain
echo -e "${OK} ${GreenBG} crontab安装完成${NC}"

post_install
echo -e "${OK} ${GreenBG} post安装完成${NC}"

bbr_install
echo -e "${OK} ${GreenBG} BBR + FQ 安装完成${NC}"

echo_xray_config
