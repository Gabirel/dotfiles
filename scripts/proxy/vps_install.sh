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

# configure for server environment
pre_install() {
    apt update -y

    # 1. install all needed tools
    apt install socat cron nginx fish vim git wget curl htop tree iperf3 rsync jq unzip -y

    # 2. change default to fish
    chsh -s /usr/bin/fish
}

install_trace() {
    # 1. download besttrace
    wget https://cdn.ipip.net/17mon/besttrace4linux.zip -O /tmp/besttrace.zip
    if [ $? -ne 0 ]; then
        echo -e "${RedBG}>>> Failed to download besttrace!${NC}"
        exit 1
    fi

    unzip /tmp/besttrace.zip
    chmod +x /tmp/besttrace/besttrace
    ln -f /tmp/besttrace/besttrace /usr/local/bin/besttrace

    # 2. download worsttrace 
    wget https://pkg.wtrace.app/linux/worsttrace -O /tmp/worsttrace
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
    template_json="ewogICJsb2ciOiB7CiAgICAibG9nbGV2ZWwiOiAid2FybmluZyIKICB9LAogICJpbmJvdW5kcyI6IFsKICAgIHsKICAgICAgInNuaWZmaW5nIjogewogICAgICAgICJlbmFibGVkIjogdHJ1ZSwKICAgICAgICAiZGVzdE92ZXJyaWRlIjogWwogICAgICAgICAgImh0dHAiLAogICAgICAgICAgInRscyIKICAgICAgICBdCiAgICAgIH0sCiAgICAgICJwb3J0IjogNDQzLAogICAgICAicHJvdG9jb2wiOiAidmxlc3MiLAogICAgICAic2V0dGluZ3MiOiB7CiAgICAgICAgImNsaWVudHMiOiBbCiAgICAgICAgICB7CiAgICAgICAgICAgICJpZCI6ICJ4eCIsCiAgICAgICAgICAgICJmbG93IjogInh0bHMtcnByeC1kaXJlY3QiLAogICAgICAgICAgICAibGV2ZWwiOiAwLAogICAgICAgICAgICAiZW1haWwiOiAibG92ZUB2MmZseS5vcmciCiAgICAgICAgICB9CiAgICAgICAgXSwKICAgICAgICAiZGVjcnlwdGlvbiI6ICJub25lIiwKICAgICAgICAiZmFsbGJhY2tzIjogWwogICAgICAgICAgewogICAgICAgICAgICAiYWxwbiI6ICIiLAogICAgICAgICAgICAicGF0aCI6ICIiLAogICAgICAgICAgICAiZGVzdCI6IDgwLAogICAgICAgICAgICAieHZlciI6IDAKICAgICAgICAgIH0KICAgICAgICBdCiAgICAgIH0sCiAgICAgICJzdHJlYW1TZXR0aW5ncyI6IHsKICAgICAgICAibmV0d29yayI6ICJ0Y3AiLAogICAgICAgICJzZWN1cml0eSI6ICJ4dGxzIiwKICAgICAgICAieHRsc1NldHRpbmdzIjogewogICAgICAgICAgImFscG4iOiBbCiAgICAgICAgICAgICJodHRwLzEuMSIKICAgICAgICAgIF0sCiAgICAgICAgICAiY2VydGlmaWNhdGVzIjogWwogICAgICAgICAgICB7CiAgICAgICAgICAgICAgImNlcnRpZmljYXRlRmlsZSI6ICIvZGF0YS92MnJheS5jcnQiLAogICAgICAgICAgICAgICJrZXlGaWxlIjogIi9kYXRhL3YycmF5LmtleSIKICAgICAgICAgICAgfQogICAgICAgICAgXQogICAgICAgIH0KICAgICAgfQogICAgfQogIF0sCiAgIm91dGJvdW5kcyI6IFsKICAgIHsKICAgICAgInByb3RvY29sIjogImZyZWVkb20iLAogICAgICAic2V0dGluZ3MiOiB7fQogICAgfSwKICAgIHsKICAgICAgInByb3RvY29sIjogImJsYWNraG9sZSIsCiAgICAgICJzZXR0aW5ncyI6IHt9LAogICAgICAidGFnIjogImJsb2NrIgogICAgfQogIF0sCiAgImRucyI6IHsKICAgICJzZXJ2ZXJzIjogWwogICAgICAiaHR0cHMrbG9jYWw6Ly9kbnMuYWRndWFyZC5jb20vZG5zLXF1ZXJ5IgogICAgXSwKICAgICJxdWVyeVN0cmF0ZWd5IjogIlVzZUlQdjQiCiAgfSwKICAicm91dGluZyI6IHsKICAgICJkb21haW5TdHJhdGVneSI6ICJJUElmTm9uTWF0Y2giLAogICAgInJ1bGVzIjogWwogICAgICB7CiAgICAgICAgInR5cGUiOiAiZmllbGQiLAogICAgICAgICJvdXRib3VuZFRhZyI6ICJibG9jayIsCiAgICAgICAgInByb3RvY29sIjogWwogICAgICAgICAgImJpdHRvcnJlbnQiCiAgICAgICAgXQogICAgICB9LAoJCQl7CiAgICAgICAgInR5cGUiOiAiZmllbGQiLAogICAgICAgICJkb21haW4iOiBbCiAgICAgICAgICAiZ2Vvc2l0ZTpnb29nbGUiCiAgICAgICAgXSwKICAgICAgICAib3V0Ym91bmRUYWciOiAiZnJlZWRvbSIKICAgICAgfSwKICAgICAgewogICAgICAgICJ0eXBlIjogImZpZWxkIiwKICAgICAgICAiZG9tYWluIjogWwogICAgICAgICAgImdlb3NpdGU6Y2F0ZWdvcnktYWRzLWFsbCIsCiAgICAgICAgICAiZ2Vvc2l0ZTpjbiIKICAgICAgICBdLAogICAgICAgICJvdXRib3VuZFRhZyI6ICJibG9jayIKICAgICAgfSwKICAgICAgewogICAgICAgICJ0eXBlIjogImZpZWxkIiwKICAgICAgICAiaXAiOiBbCiAgICAgICAgICAiZ2VvaXA6Y24iLAogICAgICAgICAgImdlb2lwOnByaXZhdGUiCiAgICAgICAgXSwKICAgICAgICAib3V0Ym91bmRUYWciOiAiYmxvY2siCiAgICAgIH0KICAgIF0KICB9Cn0="
    echo $template_json| base64 --decode > template.json

    # 3. replace new uuid
    jq --arg variable "$uuid" '.inbounds[].settings.clients[].id = $variable' template.json > /usr/local/etc/xray/config.json
}


post_install() {
    # 1. update geo file
    update-v2raydat-vps

    # 2. restart xray nginx
    systemctl restart xray nginx

    # 3. clean up
    rm -rf ./template.json
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

pre_install
echo -e "${OK} ${GreenBG} 环境预安装完成${NC}"

install_trace
echo -e "${OK} ${GreenBG} 安装Trace工具(besttrace & worsttrace)完成${NC}"

install_xray
echo -e "${OK} ${GreenBG} xray安装完成${NC}"

config_xray
echo -e "${OK} ${GreenBG} xray配置完成${NC}"

install_acme $domain
echo -e "${OK} ${GreenBG} acme安装完成${NC}"

install_crontab $domain
echo -e "${OK} ${GreenBG} crontab安装完成${NC}"

post_install
echo -e "${OK} ${GreenBG} post安装完成${NC}"

echo_xray_uuid
