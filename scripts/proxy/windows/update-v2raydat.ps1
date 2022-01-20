function Download-Geofile{
    wget https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat -OutFile tmp_geosite.dat
    wget https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat -OutFile tmp_geoip.dat
    wget https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat.sha256sum -OutFile geoip.dat.sha256sum.tmp
    wget https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat.sha256sum -OutFile geosite.dat.sha256sum.tmp
 }

 Download-Geofile

 $geoip_hash = (Get-FileHash tmp_geoip.dat | Select-Object Hash).Hash
 $geosite_hash = (Get-FileHash tmp_geosite.dat | Select-Object Hash).Hash

 $geoip_sha256sum = ((cat .\geoip.dat.sha256sum.tmp).split(' ')).Get(0)
 $geosite_sha256sum = ((cat .\geosite.dat.sha256sum.tmp).split(' ')).Get(0)

 if (($geoip_sha256sum -eq $geoip_hash) -and ( $geosite_sha256sum -eq $geosite_hash )){
    if ((Test-Path '.\geoip.dat') -and ((Test-Path '.\geosite.dat'))){
        rm .\geoip.dat
        rm .\geosite.dat
        rm .\geoip.dat.sha256sum.tmp
        rm .\geosite.dat.sha256sum.tmp

        mv .\tmp_geosite.dat .\geosite.dat
        mv .\tmp_geoip.dat .\geoip.dat
    }
    else{
        rm .\geoip.dat.sha256sum.tmp
        rm .\geosite.dat.sha256sum.tmp

        mv -Force .\tmp_geosite.dat .\geosite.dat
        mv -Force .\tmp_geoip.dat .\geoip.dat
    }
 }
 else{
    rm .\tmp_geosite.dat
    rm .\tmp_geoip.dat
    rm .\geoip.dat.sha256sum.tmp
    rm .\geosite.dat.sha256sum.tmp
 }
