#!/usr/bin/env bash
# This script is modified based on https://github.com/Loyalsoldier/v2ray-rules-dat/issues/10#issuecomment-593858015

set -e

# only works for linux
v2ray_folder="/usr/local/share/xray/"

GREEN='\033[0;32m'
NC='\033[0m'

GEOIP_URL="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat"
GEOSITE_URL="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat"

echo -e "${GREEN}>>> change directory...${NC}"
cd $v2ray_folder

echo -e "${GREEN}>>> delete old dat files...${NC}"
rm -f geoip.dat geosite.dat

echo -e "${GREEN}>>> downloading geoip.dat files...${NC}"
curl -L -O $GEOIP_URL

echo -e "${GREEN}>>> downloading geosite.dat files...${NC}"
curl -L -O $GEOSITE_URL

echo -e "${GREEN}Finished!!${NC}"
