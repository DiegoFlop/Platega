#!/bin/bash
# Script creado por Fernández López, Diego
# En este script lo que haremos sera leer el archivo reservas.csv del que obtendremos
# los datos para crear la reserva, en caso de que exista pasamos un registro a nuestro
# log con la incidencia
#------------------------------------#
#            Variables               #
#------------------------------------#
source /mnt/floppy/000_variables.sh
source ../Funciones/DHCP_funciones.sh

############################################################################
# Advertimos de que configuren las zonas antes de continuar con la Instalación y
# creación de ambitos.
read -rsp $'Por favor antes de continuar asegurese de tener configurado el archivo
de reservas en /Configuracion/reservas.csv para ello
 puede conectarse de forma remota por SSH, con Notepad, otra terminal
una vez que esté seguro de que esta configurado pulse ENTER...\n'

# Eliminamos el ENTER del Sistema Widows para dejarlo como el sistema Linux
sed -i 's/\r//g' ../Configuracion/reservas.csv

for i in $(cat $ReservasDHCP | grep "^[0-9].*" | cut  -d"," -f3)
do

if [ $(grep "^# Reserva ip host $i" /etc/dhcp/dhcpd.conf |wc -l) = 1 ]
	then
	echo "$FechaLog El host $i ya existe" >> ../Salidas/DHCP.sal
	cat /etc/dhcp/dhcpd.conf | grep -A 5 "$i" >> ../Salidas/DHCP.sal
	else
	echo "# Reserva ip host $(cat $ReservasDHCP | grep  $i |cut -d"," -f2)
		host $(cat $ReservasDHCP | grep  $i |cut -d"," -f2) {
		hardware ethernet $(cat $ReservasDHCP | grep  $i | cut -d"," -f1);
		fixed-address $i;
		ddns-hostname \"$(cat $ReservasDHCP | grep  $i |cut -d"," -f2)\";
    }
    " >> /etc/dhcp/dhcpd.conf
  echo "$FechaLog Añadimos la reserva de $(cat $ReservasDHCP | grep  $i |cut -d"," -f2)
   con la direccion MAC $(cat $ReservasDHCP | grep  $i | cut -d"," -f1) y direccion IP $i" >> ../Salidas/DHCP.sal
fi
done

# Reiniciamos el servicio de DHCP
/etc/init.d/isc-dhcp-server restart
