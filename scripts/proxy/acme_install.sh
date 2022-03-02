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

# 1. install socat: apt install socat -y
# 2. install acme: curl https://get.acme.sh | sh
pre_install() {
    # 1. install socat & crontab
    apt install socat cron -y

    # 2. install acme
    curl https://get.acme.sh | sh
}

acme() {
	"$HOME"/.acme.sh/acme.sh --set-default-ca --server letsencrypt
	echo -e "${OK} ${GreenBG} 使用letsencrypt的server，不使用ZeroSSL ${NC}"

    if "$HOME"/.acme.sh/acme.sh --issue -d "${domain}" --standalone -k ec-256 --force --test; then
        echo -e "${OK} ${GreenBG} SSL 证书测试签发成功，开始正式签发 ${NC}"
        rm -rf "$HOME/.acme.sh/${domain}_ecc"
        sleep 2
    else
        echo -e "${Error} ${RedBG} SSL 证书测试签发失败 ${NC}"
        rm -rf "$HOME/.acme.sh/${domain}_ecc"
        exit 1
    fi

    if "$HOME"/.acme.sh/acme.sh --issue -d "${domain}" --standalone -k ec-256 --force; then
        echo -e "${OK} ${GreenBG} SSL 证书生成成功 ${NC}"
        sleep 2
        mkdir /data
        if "$HOME"/.acme.sh/acme.sh --installcert -d "${domain}" --fullchainpath /data/v2ray.crt --keypath /data/v2ray.key --ecc --force; then
            echo -e "${OK} ${GreenBG} 证书配置成功 ${NC}"
            sleep 2
        fi
    else
        echo -e "${Error} ${RedBG} SSL 证书生成失败 ${NC}"
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
acme
after_install

