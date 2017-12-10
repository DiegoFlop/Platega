#!/bin/bash
# Script creado por Fernández López, Diego
#######################################
#              Variables              #
#######################################
source ../000_variables.sh



# Instalamos el servicio NFS
apt install nfs-kernel-server -y

echo "
$DirUsers	$IPRed/$MaskRed(rw)
$DirComun		$IPRed/$MaskRed(rw)" >> /etc/exports

service nfs-kernel-server restart

exportfs -v >> ..Salidas/NFS.sal

exportfs -ra >> ..Salidas/NFS.sal
