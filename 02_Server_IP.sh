#!/bin/bash
# Script creado por Fernández López, Diego
#
source 000_variables.sh
#
# En este script lo primero que haremos sera crear un backup del archivo interfaces
# original y después sobre escribirlo por la configuración deseada. Hecho esto
# reiniciaremos el servicio y posteriormente instalaremos el paquete resolvconf
# el cual nos permitirá trabajar con toda la configuración desde el propio archivo
# interfaces

cp /etc/network/interfaces /etc/network/interfaces_$Fecha.bak
echo "
auto lo
iface lo inet loopback

auto $TarjetaServer
iface $TarjetaServer inet static
	address $ServerIp/$ServerMask
	gateway $ServerGate
  dns-nameservers $ServerDns1 $ServerDns2 $ServerDns3
	dns-search $ServerDomain" > /etc/network/interfaces

/etc/init.d/networking restart | tee $Floppy/log1.sal
ls /etc/network/interfaces* >> $Floppy/log1.sal
