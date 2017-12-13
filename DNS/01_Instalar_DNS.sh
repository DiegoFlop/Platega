#!/bin/bash
# Script creado por Fernández López, Diego
# lo primero que haremos en este script es llamar a script en el que contenemos
# todos las variables y al script que contiene las posibles funciones a utilizar.
# Después instalamos BIND9. Como nuestro archivo de datos de entrada es un .csv
# para poder modificarlo cómodamente con cualquier procesador de textos como
# Open Office Calc, LibreOffice calc, Microsoft Office excel ...
# Deberemos eliminar el tipo de cambio de linea de Windows por el de Linux.
# Hechos todos estos cambios previos procederemos a crear las entradas para nuestra/s
# zona/s directa/s y/o inversa/s con los datos procedentes del archivo creado anteriormente.
# También crearemos los archivos de que contendrán los registros de DNS si no existen
# Y los archivos CSV para cada zona para poder añadir los registros en caso de no existir.
# También crearemos archivos de salida para llevar un pequeño control de errores o
# información de como se ejecuta nuestro script en /Salidas/DNS.sal

######################################
#            Variables               #
######################################
source ../000_variables.sh
source ../Funciones/DNS_funciones.sh
######################################
#    Instalacion de servicios        #
######################################
apt install bind9 -y

############################################################################
# Advertimos de que configuren las zonas antes de continuar con la Instalación y
# creación de zonas.
read -rsp $'Por favor antes de continuar asegurese de tener configurado el archivo 
/Configuracion/zonasDNS.csv para ello puede conectarse de forma remota por SSH,
con Notepad, otra terminal una vez que esté seguro de que esta configurado pulse ENTER...\n'
############################################################################
# Eliminamos el ENTER del Sistema Windows para dejarlo como el sistema Linux
sed -i 's/\r//g' $ConfZonas

######################################
#       Creacion zona directa        #
######################################
for i in $(cat $ConfZonas | grep -v "#" | cut -d "," -f1)
do
# Comprobamos si en el archivo named.conf.local ya existe la zona directa
	if [[ $(grep "^# Zona $i" ${DirConfDNS}named.conf.local | wc -l) = 1 ]]
		then
			echo "$FechaLog La zona directa: \"$i\" ya existe" >> ../Salidas/DNS.sal
		else
			echo "# Zona $i
			zone \"$i\" {
				type master;
				file \"db.$i\";
			};
			" >> ${DirConfDNS}named.conf.local
	fi
# Llamamos a la función:
		compr_DNS_reg
# Comprobamos si existe el archivo csv donde añadiremos nuestros registros.
	if test -f ${DirConf}db.${i}.csv
		then
			echo "$FechaLog El archivo: ${DirConf}db.${i}.csv  ya existe" >> ../Salidas/DNS.sal
		else
			echo -e '#[TIPO DE REGISTRO],[HOSTNAME],[ALIAS],[IPHOST],[PRIORIDAD],[COMENTARIOS]' > ${DirConf}db.${i}.csv
			echo "$FechaLog Creamos el archivo  ${DirConf}db.${i}.csv" >> ../Salidas/DNS.sal
	fi
done
############################################################################
######################################
#       Creacion zona inversa        #
######################################
for i in $(cat $ConfZonas | grep -v "#" | cut -d "," -f2)
do

iprev=(`echo "$i" | cut -d. -f1` `echo "$i" | cut -d. -f2` `echo "$i" | cut -d. -f3` `echo "$i" | cut -d. -f4`)

	if [[ $(grep "^# Zona $i" ${DirConfDNS}named.conf.local | wc -l) = 1 ]]
		then
			echo "$FechaLog La zona iversa: \"$i\" ya existe" >> ../Salidas/DNS.sal
		else
			echo "# Zona $i
			zone \"${iprev[2]}.${iprev[1]}.${iprev[0]}.in-addr.arpa\" {
			type master;
			file \"db.$i\";
			};
			" >> ${DirConfDNS}named.conf.local
		# Copiamos el archivo de la zona directa vacio para mantener los cambios basicos sin registros
		cp ${DirDbDNS}db.$(cat $ConfZonas | grep "i" | cut -d "," -f1) ${DirDbDNS}db.$i
	fi
done
