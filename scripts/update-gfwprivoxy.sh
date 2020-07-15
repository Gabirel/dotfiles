#!/usr/bin/env bash
# Modified from: https://gist.github.com/shellexy/518189b2dee475215e0c56f7ef3c9196
# Works for macOS only

## 让 privoxy 代理服务器使用 gfwlist 自动分流
## 安装需要的包，gfwlist2privoxy 暂时只支持 py2.7 所以需要修改下::
# pip2 install --user gfwlist2privoxy

## 用户规则
cat > /tmp/user.rule <<EOF
ip.gs
.github.com
.gitlab.com
download.mono-project.com
.cloudfront.net
EOF

## 生成 gfwlist.action 后刷新 privoxy
time gfwlist2privoxy -p 127.0.0.1:10808 -t socks5 -f /tmp/gfwlist.action --user-rule /tmp/user.rule &&
    cp /tmp/gfwlist.action /usr/local/etc/privoxy/ &&
    brew services restart privoxy &&
    echo "Cleaning up...." && 
    rm /tmp/gfwlist.action /tmp/user.rule
