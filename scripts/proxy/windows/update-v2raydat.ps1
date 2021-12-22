 wget https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat -OutFile tmp_geosite.dat
 wget https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat -OutFile tmp_geoip.dat

 rm .\geoip.dat
 rm .\geosite.dat

 mv .\tmp_geosite.dat .\geosite.dat
 mv .\tmp_geoip.dat .\geoip.dat