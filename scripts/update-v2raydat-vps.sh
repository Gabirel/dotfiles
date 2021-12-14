#!/usr/bin/env bash
# This script is modified based on https://github.com/Loyalsoldier/v2ray-rules-dat/issues/10#issuecomment-593858015

set -e

# only works for linux
v2ray_folder="/usr/local/share/xray/"

GREEN='\033[0;32m'
NC='\033[0m'

GEOIP_URL="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat"
GEOSITE_URL="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat"

CN_GEOIP_URL="https://cdn.jsdelivr.net/gh/Loyalsoldier/v2ray-rules-dat@release/geoip.dat"
CN_GEOSITE_URL="https://cdn.jsdelivr.net/gh/Loyalsoldier/v2ray-rules-dat@release/geosite.dat"


echo -e "${GREEN}>>> change directory...${NC}"
cd $v2ray_folder

echo -e "${GREEN}>>> delete old dat files...${NC}"
rm -f geoip.dat geosite.dat
retVal=$?
if [ $retVal -eq 1 ]; then
    echo "failed to remove geoip and geosite"
    exit 1
fi

echo -e "${GREEN}>>> downloading geoip.dat files...${NC}"
curl -L -O $GEOIP_URL
retVal=$?
if [ $retVal -eq 1 ]; then
    curl -L -O $CN_GEOIP_URL
fi


echo -e "${GREEN}>>> downloading geosite.dat files...${NC}"
curl -L -O $GEOSITE_URL
retVal=$?
if [ $retVal -eq 1 ]; then
    curl -L -O $CN_GEOSITE_URL
fi

echo -e "${GREEN}Finished for geoip/geosite!${NC}"

# restart server
echo -e "${GREEN}>>> Restart xray servers..${NC}"
systemctl restart xray
echo -e "${GREEN}All Finished!!${NC}"
