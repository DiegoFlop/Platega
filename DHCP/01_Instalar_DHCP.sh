#!/bin/bash
# Script creado por Fernández López, Diego
# Con este script instalaremos el servicio DHCP para poder ofrecer ips comodamente
# lo que hacemos es habilitar este servidor como un serivodr DHCP autorizado
# y posteriormente habilitar por que tarjeta ofrecemos el servicio. Si disponemos
# de varias tarjetas no podriamos usar este script.
# Una vez indica la tarjeta a usar sacamos un registro para comprobar posteriormente
# cual fue el resultado.
######################################
#            Variables               #
######################################
source ../000_variables.sh
source ../Funciones/DHCP_funciones.sh
#######################################
#           Instalamos DHCP           #
#######################################
apt install isc-dhcp-server -y

#######################################
#        Configuracion Inicial        #
#######################################
if [[ $(grep "^authoritative;" $ConfDHCP | wc -l) = 0 ]]
	then
		sed -i "/#authoritative/ aauthoritative;" $ConfDHCP
	else
		echo "El Servidor DHCP de $HOSTNAME ya esta autorizado" >> ../Salidas/DHCP.sal
fi


if [ $( grep INTERFACESv4=\"$(ifconfig -s | sed -e '1d' | grep -v lo | cut -d" " -f1)\" $ConfDefDHCP |wc -l) == 0 ]
	then
	sed -i 's#INTERFACESv4="#&'"$(ifconfig -s | sed -e '1d' | grep -v lo | cut -d" " -f1)"'#g' $ConfDefDHCP
  echo "$FechaLog Configuramos $(ifconfig -s | sed -e '1d' | grep -v lo | cut -d" " -f1) para usar como \
  tarjeta para el servicio DHCP" >> ../Salidas/DHCP.sal
	else
	echo "$FechaLog Las interfaces $(ifconfig -s | sed -e '1d' | grep -v lo | cut -d" " -f1) \
	para el uso de DHCP estan configuradas" >> ../Salidas/DHCP.sal
fi
