#!/usr/bin/env bash
# This script is modified based on https://github.com/Loyalsoldier/v2ray-rules-dat/issues/10#issuecomment-593858015

set -e

# only works for macOS
v2ray_folder="/usr/local/Cellar/v2ray-core/4.30.0/bin"

GREEN='\033[0;32m'
NC='\033[0m'

GEOIP_URL="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat"
GEOSITE_URL="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat"

GEOIP_NAME="geoip.dat"
GEOSITE_NAME="geosite.dat"

echo -e "${GREEN}>>> downloading geoip.dat files...${NC}"
curl -L -O $GEOIP_URL

echo -e "${GREEN}>>> downloading geosite.dat files...${NC}"
curl -L -O $GEOSITE_URL

echo -e "${GREEN}>>> delete old dat files...${NC}"
rm -f $v2ray_folder/$GEOIP_NAME $v2ray_folder/$GEOSITE_NAME

echo -e "${GREEN}>>> Replacing new geoip/geosite...${NC}"
mv ./$GEOIP_NAME $v2ray_folder/
mv ./$GEOSITE_NAME $v2ray_folder/

echo -e "${GREEN}Finished!!${NC}"
