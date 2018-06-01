1. Backup system

> pacman -Qqe > pkglist.txt

2. Restore system:

> pacman -S - < pkglist.txt

3. List all packages installed via AUR 

> sudo pacman -Qqem

4. use the following commands to update COLLATE

> localectl set-locale LC_COLLATE=zh_CN.UTF-8