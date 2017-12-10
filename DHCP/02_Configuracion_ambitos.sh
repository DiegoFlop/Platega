#!/bin/bash
# Script creado por Fernández López, Diego
# Con este configuraremos los ámbitos para el DHCP lo primero que hacemos es
# crear variables temporales que tomaran los valores del csv de ámbitos una vez tomados
# los agregamos a /etc/dhcp/dhcpd.conf y comprobamos que no exista ya el ámbito.
######################################
#            Variables               #
######################################
source ../000_variables.sh
source ../Funciones/DHCP_funciones.sh

############################################################################
# Advertimos de que configuren las zonas antes de continuar con la Instalación y
# creación de ambitos.
read -rsp $'Por favor antes de continuar asegurese de tener configurado el archivo
de ambitos en /Configuracion/ambitos.csv para ello
 puede conectarse de forma remota por SSH, con Notepad, otra terminal
una vez que esté seguro de que esta configurado pulse ENTER...\n'

# Eliminamos el ENTER del Sistema Widows para dejarlo como el sistema Linux
sed -i 's/\r//g' $AmbitosDHCP

for i in $(cat $AmbitosDHCP | grep "^[1-9].*" | cut -d"," -f1);
do
mascara=$(cat $AmbitosDHCP | grep -n $i |cut -d"," -f2 )
router=$(cat $AmbitosDHCP | grep -n $i |cut -d"," -f3 )
dns1=$(cat $AmbitosDHCP | grep -n $i |cut -d"," -f4 )
dns2=$(cat $AmbitosDHCP | grep -n $i |cut -d"," -f5 )
dns3=$(cat $AmbitosDHCP | grep -n $i |cut -d"," -f6 )
dominio=$(cat $AmbitosDHCP | grep -n $i |cut -d"," -f7 )
iniciorango=$(cat $AmbitosDHCP | grep -n $i |cut -d"," -f8 )
finrango=$(cat $AmbitosDHCP | grep -n $i |cut -d"," -f9 )
comprobarambito=$(grep "^# Ambito $i" $ConfDHCP |wc -l)
	if [[ $comprobarambito == 1 ]]
		then
			echo "El ambito $i ya existe por favor verifique la informacion" >> ../Salidas/DHCP.sal
		else
	echo "# Ambito $i
	subnet $i netmask $mascara {
	option routers $router;
	option domain-name \"$dominio\";
	option domain-name-servers $dns1, $dns2, $dns3;
	range $iniciorango $finrango;
			}" >> $ConfDHCP
	fi
done
# Reiniciamos el servicio de DHCP
/etc/init.d/isc-dhcp-server restart
