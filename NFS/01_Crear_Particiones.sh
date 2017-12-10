#!/bin/bash
# Script creado por Fernández López, Diego
#######################################
#              Variables              #
#######################################
source ../000_variables.sh


# Covnertimos el disco a GPT
(echo g; echo w) | fdisk /dev/$Disk

#Creamos 2 particiones de 5GB
(echo n; echo ""; echo ""; echo "+$DiskSize"; echo w) | fdisk /dev/$Disk
#sleep 5
(echo n; echo ""; echo ""; echo "+$DiskSize"; echo w)  | fdisk /dev/$Disk

# Formateamos las particiones y le ponemos etiquetas
echo y | mkfs.ext4 -L Usuarios /dev/${Disk}1
echo y | mkfs.ext4 -L Comun /dev/${Disk}2

# Creamos las carpetas donde montaremos las particiones

test -d $DirUsers || mkdir $DirUsers
test -d $DirConf || mkdir $DirComun

# Añadimos al archivo fstab la ruta de montaje
if [ $(cat /etc/fstab | grep "^# LABEL:Usuarios" | wc -l) = 0 ]
then
echo "
# LABEL:Usuarios /dev/${Disk}1
UUID=$(blkid |grep "${Disk}1" | cut -d "\"" -f 4)	$DirUsers	ext4	defaults	0	0
" >> /etc/fstab
fi
if [ $(cat /etc/fstab | grep "^# LABEL:Comun" | wc -l) = 0 ]
then
echo "
# LABEL:Comun /dev/${Disk}2
UUID=$(blkid |grep "${Disk}2" | cut -d "\"" -f 4)	$DirComun	ext4	defaults	0	0
" >> /etc/fstab
fi
# montamos las nuevas unidades
mount -a
