1. Backup system

> pacman -Qqe > pkglist.txt

2. Restore system:

> pacman -S - < pkglist.txt

3. List all packages installed via AUR 

> sudo pacman -Qqem