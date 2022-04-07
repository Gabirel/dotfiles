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
    apt install jq -y
}

update_config_xray() {
    # 1. get current uuid
    xray_config='/usr/local/etc/xray/config.json'
    uuid=`jq -r '.inbounds[].settings.clients[].id' $xray_config`
    echo -e "${OK} ${GreenBG} current uuid: $uuid ${NC}"

    # 2. update xray json using base64
    template_json="ewogICJsb2ciOiB7CiAgICAiYWNjZXNzIjogIi92YXIvbG9nL3hyYXkvYWNjZXNzLmxvZyIsCiAgICAiZXJyb3IiOiAiL3Zhci9sb2cveHJheS9lcnJvci5sb2ciLAogICAgImxvZ2xldmVsIjogIndhcm5pbmciCiAgfSwKICAiaW5ib3VuZHMiOiBbCiAgICB7CiAgICAgICJzbmlmZmluZyI6IHsKICAgICAgICAiZW5hYmxlZCI6IHRydWUsCiAgICAgICAgImRlc3RPdmVycmlkZSI6IFsKICAgICAgICAgICJodHRwIiwKICAgICAgICAgICJ0bHMiCiAgICAgICAgXQogICAgICB9LAogICAgICAicG9ydCI6IDQ0MywKICAgICAgInByb3RvY29sIjogInZsZXNzIiwKICAgICAgInNldHRpbmdzIjogewogICAgICAgICJjbGllbnRzIjogWwogICAgICAgICAgewogICAgICAgICAgICAiaWQiOiAieHh4LXh4eC14eHgiLAogICAgICAgICAgICAiZmxvdyI6ICJ4dGxzLXJwcngtZGlyZWN0IiwKICAgICAgICAgICAgImxldmVsIjogMCwKICAgICAgICAgICAgImVtYWlsIjogImxvdmVAdjJmbHkub3JnIgogICAgICAgICAgfQogICAgICAgIF0sCiAgICAgICAgImRlY3J5cHRpb24iOiAibm9uZSIsCiAgICAgICAgImZhbGxiYWNrcyI6IFsKICAgICAgICAgIHsKICAgICAgICAgICAgImRlc3QiOiAiODAwMSIsCiAgICAgICAgICAgICJ4dmVyIjogMQogICAgICAgICAgfSwKICAgICAgICAgIHsKICAgICAgICAgICAgImFscG4iOiAiaDIiLAogICAgICAgICAgICAiZGVzdCI6ICI4MDAyIiwKICAgICAgICAgICAgInh2ZXIiOiAxCiAgICAgICAgICB9CiAgICAgICAgXQogICAgICB9LAogICAgICAic3RyZWFtU2V0dGluZ3MiOiB7CiAgICAgICAgIm5ldHdvcmsiOiAidGNwIiwKICAgICAgICAic2VjdXJpdHkiOiAieHRscyIsCiAgICAgICAgInh0bHNTZXR0aW5ncyI6IHsKICAgICAgICAgICJyZWplY3RVbmtub3duU25pIjogdHJ1ZSwKICAgICAgICAgICJtaW5WZXJzaW9uIjogIjEuMyIsCiAgICAgICAgICAiYWxwbiI6IFsKICAgICAgICAgICAgImgyIiwKICAgICAgICAgICAgImh0dHAvMS4xIgogICAgICAgICAgXSwKICAgICAgICAgICJjZXJ0aWZpY2F0ZXMiOiBbCiAgICAgICAgICAgIHsKICAgICAgICAgICAgICAiY2VydGlmaWNhdGVGaWxlIjogIi9kYXRhL3YycmF5LmNydCIsCiAgICAgICAgICAgICAgImtleUZpbGUiOiAiL2RhdGEvdjJyYXkua2V5IgogICAgICAgICAgICB9CiAgICAgICAgICBdCiAgICAgICAgfQogICAgICB9CiAgICB9CiAgXSwKICAib3V0Ym91bmRzIjogWwogICAgewogICAgICAicHJvdG9jb2wiOiAiZnJlZWRvbSIsCiAgICAgICJzZXR0aW5ncyI6IHt9LAogICAgICAidGFnIjogImZyZWVkb20iCiAgICB9LAogICAgewogICAgICAicHJvdG9jb2wiOiAiYmxhY2tob2xlIiwKICAgICAgInNldHRpbmdzIjoge30sCiAgICAgICJ0YWciOiAiYmxvY2siCiAgICB9CiAgXSwKICAiZG5zIjogewogICAgInNlcnZlcnMiOiBbCiAgICAgICIxLjEuMS4xIgogICAgXSwKICAgICJxdWVyeVN0cmF0ZWd5IjogIlVzZUlQdjQiCiAgfSwKICAicm91dGluZyI6IHsKICAgICJkb21haW5TdHJhdGVneSI6ICJJUElmTm9uTWF0Y2giLAogICAgInJ1bGVzIjogWwogICAgICB7CiAgICAgICAgInR5cGUiOiAiZmllbGQiLAogICAgICAgICJpcCI6IFsKICAgICAgICAgICIxLjEuMS4xIgogICAgICAgIF0sCiAgICAgICAgIm91dGJvdW5kVGFnIjogImZyZWVkb20iCiAgICAgIH0sCiAgICAgIHsKICAgICAgICAidHlwZSI6ICJmaWVsZCIsCiAgICAgICAgIm91dGJvdW5kVGFnIjogImJsb2NrIiwKICAgICAgICAicHJvdG9jb2wiOiBbCiAgICAgICAgICAiYml0dG9ycmVudCIKICAgICAgICBdCiAgICAgIH0sCiAgICAgIHsKICAgICAgICAidHlwZSI6ICJmaWVsZCIsCiAgICAgICAgImRvbWFpbiI6IFsKICAgICAgICAgICJnZW9zaXRlOmdvb2dsZSIKICAgICAgICBdLAogICAgICAgICJvdXRib3VuZFRhZyI6ICJmcmVlZG9tIgogICAgICB9LAogICAgICB7CiAgICAgICAgInR5cGUiOiAiZmllbGQiLAogICAgICAgICJkb21haW4iOiBbCiAgICAgICAgICAiZ2Vvc2l0ZTpjYXRlZ29yeS1hZHMtYWxsIiwKICAgICAgICAgICJnZW9zaXRlOmNuIgogICAgICAgIF0sCiAgICAgICAgIm91dGJvdW5kVGFnIjogImJsb2NrIgogICAgICB9LAogICAgICB7CiAgICAgICAgInR5cGUiOiAiZmllbGQiLAogICAgICAgICJpcCI6IFsKICAgICAgICAgICJnZW9pcDpjbiIsCiAgICAgICAgICAiZ2VvaXA6cHJpdmF0ZSIKICAgICAgICBdLAogICAgICAgICJvdXRib3VuZFRhZyI6ICJibG9jayIKICAgICAgfQogICAgXQogIH0KfQ=="
    echo $template_json| base64 --decode > template.json

    # 3. replace new uuid
    jq --arg variable "$uuid" '.inbounds[].settings.clients[].id = $variable' template.json > /usr/local/etc/xray/config.json
}

echo_xray_uuid() {
    current_config_xray='/usr/local/etc/xray/config.json'
    uuid=`jq -r '.inbounds[].settings.clients[].id' $current_config_xray`
    echo -e "${OK} ${GreenBG} Your uuid: $uuid ${NC}"
}

pre_install
echo -e "${OK} ${GreenBG} 环境预安装完成${NC}"

update_config_xray
echo -e "${OK} ${GreenBG} xray配置修改完成${NC}"

echo_xray_uuid
