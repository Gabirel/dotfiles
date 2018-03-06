@PowerShell -ExecutionPolicy Bypass -Command Invoke-Expression $('$args=@(^&{$args} %*);'+[String]::Join(';',(Get-Content '%~f0') -notmatch '^^@PowerShell.*EOF$')) & goto :EOF

echo "Welcome to use~~"
echo "Author: Gabriel  o(￣ε￣*)"
echo "github: https://github.com/gabirel"
echo "It's only for studying purpose!!"
echo "Description：Move all files of directory B under A into the parent directory recursively, which is directory A"
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
$source = Read-Host "[*] Please input the source path"
$dest = Read-Host "[*] Please input the destination(if it's where the source path is, press Enter to continue)"

if ($dest -eq [string]::empty) {
    $dest = $source
}
echo ""
echo ""
echo "[!!] $source  >>  $dest"
sleep 1

echo "[*] Confirming……"
$shell = new-object -comobject "WScript.Shell"
$result = $shell.popup("Are you sure to move? It's IRREVERSIBLE!!",0,"Confirming Window",4+32)
if($result -eq 7) {
	echo ""
	echo "[!!] I'm exiting ~(￣┰￣*)"
	sleep 1
	Exit
}

echo ""
echo ""
echo "[*] Start to move……"
sleep 1

echo "[*] Moving……"

Get-ChildItem -Path $source -Recurse -File | Move-Item -Destination $dest -Force 
Get-ChildItem -Path $source -Recurse -Directory | Remove-Item -Recurse

echo ""
echo "[*] Moving finished!!"
echo ""
$shell2 = new-object -comobject "WScript.Shell"
$result2 = $shell.popup("Do you want me to open the destination folder for you?",0,"Question",4+32)
if($result2 -eq 7) {
	echo ""
	echo "[!!] ByeBye ~(￣┰￣*)"
	sleep 1
	Exit
}

echo ""
echo "[*] Preparing for opening folder for you...I know how to exit myself ~(￣┰￣*)"
sleep 2
Pause

Invoke-Item $dest
echo ""

Exit-PSSession