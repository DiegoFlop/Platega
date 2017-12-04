#!/bin/bash
# Script creado por Fernández López, Diego
#
source 000_variables.sh
#
# En este script instalaremos de forma automática las Guest Additions siempre
# que nuestra versión de VirtualBox admita la instalación de las Guest Additions
# en nuestra maquina virtual.
test -d /mnt/cdrom || mkdir -p /mnt/cdrom

echo "Compruebe que tiene insertado el CD-ROM de Virtualox de no ser así introdúzcalo ahora"
read -rsp $'Pulse continuar cuando este listo ...\n'

mount /dev/cdrom /mnt/cdrom
apt-get install -y build-essential module-assistant
(echo "Y") | m-a prepare
cp /mnt/cdrom/VBoxLinuxAdditions.run /tmp/
cd /tmp/
chmod 755 VBoxLinuxAdditions.run
sh VBoxLinuxAdditions.run
rm /tmp/VBoxLinuxAdditions.run
reboot
