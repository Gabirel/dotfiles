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

CORE_LATEST_URL="https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip"

# configure for server environment
pre_install() {
    apt update -y

    # 1. install all needed tools
    apt install jq -y
}

update_xray_core() {
    # need to stop first to avoid "text busy" issue
    systemctl stop xray

    # 1. download latest version
    wget $CORE_LATEST_URL -O /tmp/core.zip

    # 2. unzip with overwrite option
    unzip -o /tmp/core.zip -d /tmp/core

    # 3. apply bin
    cp /tmp/core/xray /usr/local/bin/xray

    # clean up
    rm -rf /tmp/core.zip /tmp/core
}

update_config_xray() {
    # 1. get current uuid
    xray_config='/usr/local/etc/xray/config.json'
    uuid=`jq -r '.inbounds[].settings.clients[].id' $xray_config`
    echo -e "${OK} ${GreenBG} current uuid: $uuid ${NC}"

    # 2. update xray json using base64
    template_json="ewogICJsb2ciOiB7CiAgICAiYWNjZXNzIjogIi92YXIvbG9nL3hyYXkvYWNjZXNzLmxvZyIsCiAgICAiZXJyb3IiOiAiL3Zhci9sb2cveHJheS9lcnJvci5sb2ciLAogICAgImxvZ2xldmVsIjogIndhcm5pbmciCiAgfSwKICAiaW5ib3VuZHMiOiBbCiAgICB7CiAgICAgICJzbmlmZmluZyI6IHsKICAgICAgICAiZW5hYmxlZCI6IHRydWUsCiAgICAgICAgImRlc3RPdmVycmlkZSI6IFsKICAgICAgICAgICJodHRwIiwKICAgICAgICAgICJ0bHMiCiAgICAgICAgXQogICAgICB9LAogICAgICAicG9ydCI6IDQ0MywKICAgICAgInByb3RvY29sIjogInZsZXNzIiwKICAgICAgInNldHRpbmdzIjogewogICAgICAgICJjbGllbnRzIjogWwogICAgICAgICAgewogICAgICAgICAgICAiaWQiOiAieHh4LXh4eC14eHgiLAogICAgICAgICAgICAiZmxvdyI6ICJ4dGxzLXJwcngtdmlzaW9uIiwKICAgICAgICAgICAgImxldmVsIjogMCwKICAgICAgICAgICAgImVtYWlsIjogImxvdmVAdjJmbHkub3JnIgogICAgICAgICAgfQogICAgICAgIF0sCiAgICAgICAgImRlY3J5cHRpb24iOiAibm9uZSIsCiAgICAgICAgImZhbGxiYWNrcyI6IFsKICAgICAgICAgIHsKICAgICAgICAgICAgImRlc3QiOiAiODAwMSIsCiAgICAgICAgICAgICJ4dmVyIjogMQogICAgICAgICAgfSwKICAgICAgICAgIHsKICAgICAgICAgICAgImFscG4iOiAiaDIiLAogICAgICAgICAgICAiZGVzdCI6ICI4MDAyIiwKICAgICAgICAgICAgInh2ZXIiOiAxCiAgICAgICAgICB9CiAgICAgICAgXQogICAgICB9LAogICAgICAic3RyZWFtU2V0dGluZ3MiOiB7CiAgICAgICAgIm5ldHdvcmsiOiAidGNwIiwKICAgICAgICAic2VjdXJpdHkiOiAidGxzIiwKICAgICAgICAidGxzU2V0dGluZ3MiOiB7CiAgICAgICAgICAicmVqZWN0VW5rbm93blNuaSI6IHRydWUsCiAgICAgICAgICAibWluVmVyc2lvbiI6ICIxLjMiLAogICAgICAgICAgImFscG4iOiBbCiAgICAgICAgICAgICJoMiIsCiAgICAgICAgICAgICJodHRwLzEuMSIKICAgICAgICAgIF0sCiAgICAgICAgICAiY2VydGlmaWNhdGVzIjogWwogICAgICAgICAgICB7CiAgICAgICAgICAgICAgImNlcnRpZmljYXRlRmlsZSI6ICIvZGF0YS92MnJheS5jcnQiLAogICAgICAgICAgICAgICJrZXlGaWxlIjogIi9kYXRhL3YycmF5LmtleSIKICAgICAgICAgICAgfQogICAgICAgICAgXQogICAgICAgIH0KICAgICAgfQogICAgfQogIF0sCiAgIm91dGJvdW5kcyI6IFsKICAgIHsKICAgICAgInByb3RvY29sIjogImZyZWVkb20iLAogICAgICAic2V0dGluZ3MiOiB7fSwKICAgICAgInRhZyI6ICJmcmVlZG9tIgogICAgfSwKICAgIHsKICAgICAgInByb3RvY29sIjogImJsYWNraG9sZSIsCiAgICAgICJzZXR0aW5ncyI6IHt9LAogICAgICAidGFnIjogImJsb2NrIgogICAgfQogIF0sCiAgImRucyI6IHsKICAgICJzZXJ2ZXJzIjogWwogICAgICAiMS4xLjEuMSIKICAgIF0sCiAgICAicXVlcnlTdHJhdGVneSI6ICJVc2VJUHY0IgogIH0sCiAgInJvdXRpbmciOiB7CiAgICAiZG9tYWluU3RyYXRlZ3kiOiAiSVBJZk5vbk1hdGNoIiwKICAgICJydWxlcyI6IFsKICAgICAgewogICAgICAgICJ0eXBlIjogImZpZWxkIiwKICAgICAgICAiaXAiOiBbCiAgICAgICAgICAiMS4xLjEuMSIKICAgICAgICBdLAogICAgICAgICJvdXRib3VuZFRhZyI6ICJmcmVlZG9tIgogICAgICB9LAogICAgICB7CiAgICAgICAgInR5cGUiOiAiZmllbGQiLAogICAgICAgICJvdXRib3VuZFRhZyI6ICJibG9jayIsCiAgICAgICAgInByb3RvY29sIjogWwogICAgICAgICAgImJpdHRvcnJlbnQiCiAgICAgICAgXQogICAgICB9LAogICAgICB7CiAgICAgICAgInR5cGUiOiAiZmllbGQiLAogICAgICAgICJkb21haW4iOiBbCiAgICAgICAgICAiZ2Vvc2l0ZTpnb29nbGUiCiAgICAgICAgXSwKICAgICAgICAib3V0Ym91bmRUYWciOiAiZnJlZWRvbSIKICAgICAgfSwKICAgICAgewogICAgICAgICJ0eXBlIjogImZpZWxkIiwKICAgICAgICAiZG9tYWluIjogWwogICAgICAgICAgImdlb3NpdGU6Y2F0ZWdvcnktYWRzLWFsbCIsCiAgICAgICAgICAiZ2Vvc2l0ZTpjbiIKICAgICAgICBdLAogICAgICAgICJvdXRib3VuZFRhZyI6ICJibG9jayIKICAgICAgfSwKICAgICAgewogICAgICAgICJ0eXBlIjogImZpZWxkIiwKICAgICAgICAiaXAiOiBbCiAgICAgICAgICAiZ2VvaXA6Y24iLAogICAgICAgICAgImdlb2lwOnByaXZhdGUiCiAgICAgICAgXSwKICAgICAgICAib3V0Ym91bmRUYWciOiAiYmxvY2siCiAgICAgIH0KICAgIF0KICB9Cn0"
    echo $template_json| base64 --decode > /tmp/template.json

    # 3. replace new uuid
    jq --arg variable "$uuid" '.inbounds[].settings.clients[].id = $variable' /tmp/template.json > /usr/local/etc/xray/config.json
}

echo_xray_uuid() {
    current_config_xray='/usr/local/etc/xray/config.json'
    uuid=`jq -r '.inbounds[].settings.clients[].id' $current_config_xray`
    echo -e "${OK} ${GreenBG} Your uuid: $uuid ${NC}"
}

restart_services() {
    systemctl restart xray nginx
}

pre_install
echo -e "${OK} ${GreenBG} 环境预安装完成${NC}"

update_xray_core
echo -e "${OK} ${GreenBG} xray core更新至以下版本：${NC}"
xray version

update_config_xray
echo -e "${OK} ${GreenBG} xray配置修改完成${NC}"

restart_services
echo -e "${OK} ${GreenBG} xray和nginx服务重启完成${NC}"

echo_xray_uuid
