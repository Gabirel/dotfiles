@PowerShell -ExecutionPolicy Bypass -Command Invoke-Expression $('$args=@(^&{$args} %*);'+[String]::Join(';',(Get-Content '%~f0') -notmatch '^^@PowerShell.*EOF$')) & goto :EOF

echo "欢迎使用~"
echo "作者：Gabriel  o(￣ε￣*)"
echo "主页：https://github.com/gabirel"
echo "仅用作学习交流用!!"
echo "程序功能：将A目录里的所有子目录里的文件（可递归）移动到A目录下"
echo ""

Function Pause ($Message = "Press any key to continue . . . ") {
    if ((Test-Path variable:psISE) -and $psISE) {
        $Shell = New-Object -ComObject "WScript.Shell"
        $Button = $Shell.Popup("Click OK to continue.", 0, "Script Paused", 0)
    } else {     
        Write-Host -NoNewline $Message
        [void][System.Console]::ReadKey($true)
        Write-Host
    }
}


echo ""
$source = Read-Host "[*] 请移动要操作的源路径"
$dest = Read-Host "[*] 请移动目的路径(若与源路径相同，直接回车)"

if ($dest -eq [string]::empty) {
    $dest = $source
}
echo ""
echo ""
echo "[!!] $source  >>  $dest"
sleep 1

echo "[*] 确认弹窗结果中……"
$shell = new-object -comobject "WScript.Shell"
$result = $shell.popup("是否确认移动？此操作不可逆转噢!!",0,"确认窗口",4+32)
if($result -eq 7) {
	echo ""
	echo "[!!] 退出啦 ~(￣┰￣*)"
	sleep 1
	Exit
}

echo ""
echo ""
echo "[*] 开始移动……"
sleep 1

echo "[*] 移动中……"

Get-ChildItem -Path $source -Recurse -File | Move-Item -Destination $dest -Force 
Get-ChildItem -Path $source -Recurse -Directory | Remove-Item -Recurse

echo ""
echo "[*] 移动完成!!"
echo ""
$shell2 = new-object -comobject "WScript.Shell"
$result2 = $shell.popup("是否帮您打开呢？",0,"Question",4+32)
if($result2 -eq 7) {
	echo ""
	echo "[!!] 拜拜 ~(￣┰￣*)"
	sleep 1
	Exit
}

echo ""
echo "[*] 为您准备打开目的文件夹……我会自动退出哒 ~(￣┰￣*)"
sleep 2
Pause

Invoke-Item $dest
echo ""

Exit-PSSession