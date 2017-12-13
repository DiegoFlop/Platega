#!/bin/bash
# Script creado por Fernández López, Diego
# En este script lo primero que haremos sera crear un backup del archivo interfaces
# original y después sobre escribirlo por la configuración deseada. Hecho esto
# reiniciaremos el servicio y posteriormente instalaremos el paquete resolvconf
# el cual nos permitirá trabajar con toda la configuración desde el propio archivo
# interfaces

#######################################
#              Variables              #
#######################################
source ../000_variables.sh


cp /etc/network/interfaces /etc/network/interfaces_$Fecha.bak
echo "# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface


auto $TarjetaServer
iface $TarjetaServer inet static
	address $ServerIp/$ServerMask
	gateway $ServerGate
	dns-nameservers $ServerDns1 $ServerDns2 $ServerDns3
	dns-search $ServerDomain" > /etc/network/interfaces

	/etc/init.d/networking restart | tee ${DirSal}ConfiguracionSer.sal
	cat /etc/network/interfaces | grep $TarjetaServer -A7 >> ${DirSal}ConfiguracionSer.sal
