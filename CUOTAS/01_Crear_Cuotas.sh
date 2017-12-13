#!/bin/bash
# Script creado por Fernández López, Diego
# En este script instalamos las cuotas. Cambiamos fstab para configurar las cuotas
# volvemos a montar los puntos que cambiamos la configuracion de fstab
# Desactivamos las cuotas para poder configurarlas
# Creamos los archivos de cuotas
# Iniciamos las cuotas
# Creamos 2 usuarios para crear las plantillas de cuota
######################################
#            Variables               #
######################################
source ../000_variables.sh

# Instalamos las cuotas
apt install quota -y

# Sustituir "defaults" por " defaults,usrquota,grpquota" par el UUID disk1

cambio=$(cat /etc/fstab | grep "$(blkid | grep /dev/${Disk}1 | cut -d"\"" -f 4)" | cut -f1)
sed -i '/'$cambio'/s/defaults/defaults,usrquota,grpquota/g' /etc/fstab

# Sustituir "defaults" por " defaults,usrquota,grpquota" par el UUID disk2
cambio=$(cat /etc/fstab | grep "$(blkid | grep /dev/${Disk}2 | cut -d"\"" -f 4)" | cut -f1)
sed -i '/'$cambio'/s/defaults/defaults,usrquota,grpquota/g' /etc/fstab

mount -o remout $DirUsers
mount -o remout $DirComun

quotacheck -avug
quotaoff -avug
quotacheck -avug
quotaon -av

useradd profe -M -N -u 1001
useradd alumno  -M -N -u 1002
echo "$FechaLog $(cat /etc/passwd |!:)" >> ../Salidas/CUOTAS.sal

setquota -u profe   $CuotaSoftP $CuotaHardP 0 0 $DirUsers
setquota -u alumno  $CuotaSoftA $CuotaHardA 0 0 $DirUsers

repquota >> ../Salidas/CUOTAS.sal
