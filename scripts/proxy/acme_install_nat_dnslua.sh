#!/usr/bin/env bash
# Only works under Debian/Ubuntu

#fonts color
Green="\033[32m"
Red="\033[31m"
# Yellow="\033[33m"
GreenBG="\033[42;37m"
RedBG="\033[41;37m"
Font="\033[0m"

#notification information
# Info="${Green}[信息]${Font}"
OK="${Green}[OK]${Font}"
Error="${Red}[错误]${Font}"

# 1. install socat: apt install socat -y
# 2. install acme: curl https://get.acme.sh | sh
pre_install() {
    # 1. check or install socat
    [[ "$(command -v socat)" ]] || { 
        echo "socat is not installed. Now install socat" 1>&2 ; 
        apt install socat -y
    }

    # 2. check or install acme
    if [ ! -d "$HOME"/.acme.sh/ ]; then
        echo "acme.sh is not installed. Now install acme.sh" 1>&2 ; 
        curl https://get.acme.sh | sh
    fi
    echo -e "${OK} ${GreenBG} 基础环境检查完成 ${Font}"
}

# check LUA_DNS config
env_check() {
    # export LUA_Key="xxxxxxxxxxxxxxxxxxxxxxxx"
    if test -z "$LUA_Key"; then
        echo -e "${Error} ${RedBG} Environment Variable \$LUA_Key is not set ${Font}"
        exit 1
    fi
    # export LUA_Email="xxxx@xxx.com"
    if test -z "$LUA_Email"; then
        echo -e "${Error} ${RedBG} Environment Variable \$LUA_Email is not set ${Font}"
        exit 1
    fi
    echo -e "${OK} ${GreenBG} LUA_DNS设置检测通过 ${Font}"
}
acme() {
    if "$HOME"/.acme.sh/acme.sh --issue --dns dns_lua -d "${domain}" -k ec-256 --force; then
        echo -e "${OK} ${GreenBG} SSL 证书生成成功 ${Font}"
        sleep 2
        mkdir /data
        if "$HOME"/.acme.sh/acme.sh --installcert -d "${domain}" --fullchainpath /data/v2ray.crt --keypath /data/v2ray.key --ecc --force; then
            echo -e "${OK} ${GreenBG} 证书配置成功 ${Font}"
            sleep 2
        fi
    else
        echo -e "${Error} ${RedBG} SSL 证书生成失败 ${Font}"
        rm -rf "$HOME/.acme.sh/${domain}_ecc"
        exit 1
    fi
}

after_install() {
    # make data readable
    chmod +r /data/*
}

# domain must be set
if [[ $# -ne 1 ]]; then
    echo -e "${RedBG}>>> domain must be set!${NC}"
    exit 1
fi
domain=$1

pre_install
env_check
acme
after_install

