#!/bin/bash
# Script creado por Fernández López, Diego
# lo primero que haremos en este script es llamar a script en el que contenemos
# todos las variables y al script que contiene las posibles funciones a utilizar.
# Después lo primero que haremos sera accer una copiar de la variable IFS que es
# la que contiene el separador por defecto de campos que usualmente es el backsapce
# Seguidamente procederemos a realizar un FOR por si disponemos de varias zonas.
# En el FOR lo que haremos sera filtrar por el campo 1 de nuestro archivo zonas.csv
# sin coger la primera linea que es la indicadora de que valores debemos poner en
# cada campo.
# lo siguiente es ejecutar el script de re-estructuración indicando la variable externa
# dominio que usamos dentro de dicho script indicando que script de re-estructuración
# usamos y sobre que archivo lo usaremos. Para que pueda ser ejecutado para distintas
# zonas usamos las variables de for.
#
# Hecho todo lo anterior se nos generara un archivo txt en la carpeta /tmp/ por
# cada zona que tenemos en nuestro archivo de zonas.
# Ahora cambiamos el separado por defecto a un cambio de linea. Lo realizamos ahora
# ya que si lo hubiésemos realizado al principio el primer for fallaría. Y necesitamos
# cambiarlo porque sino el for internamente cojera cada valor separado por espacios
# del/los archivos generados con AWK lo que no nos serviría para nada.
# Seguidamente después realizamos un subFOR que se encargara de añadir cada linea de los
# archivos generados al archivo correspondiente. Por supuesto para evitar repetir
# datos y obtener errores comprobamos primero que el registro no esté añadido
# (comprobamos que el registro no estea añadido tal cual si modificamos el archivo de
# estructura o manualmente el archivo destino y difiere en un espacio lo añadirá
# ya que reconocerá que no es la misma linea igual que si modificamos el archivo de
# registros csv y cambiamos los nombres también reconocerá que la linea es distinta)
# Claro esta que comprobamos tanto en la db de zona directa como la inversa y añadimos
# los registros con un filtro tan simple como: si el campo 1 es PTR lo añades a la zona
# inversa pero primero compruebas si ya existe en la db de esa zona. Si no es PTR lo
# añades al db de la zona directa comprobando también si existe ya ese registro.
# En caso de existir nos sacara al archivo de Salida/DNS.sal que registro esta
# repetido y en que zona con su respectiva fecha de error.
# Por ultimo restauramos el valor original del IFS.

######################################
#            Variables               #
######################################
source ../000_variables.sh
source ../Funciones/DNS_funciones.sh

############################################################################
# Advertimos de que configuren las zonas antes de continuar con la Instalación y
# creación de zonas.
read -rsp $'Por favor antes de continuar asegurese de tener configurado el/los archivo/s de
registro de DNS de la carpeta de /Configuracion/db.******** para ello
 puede conectarse de forma remota por SSH, con Notepad, otra terminal
una vez que esté seguro de que esta configurado pulse ENTER...\n'
############################################################################

SaveIFS=$IFS
for i in $(cat $ConfZonas | grep -v "#" | cut -d "," -f1)
do
	awk  -v dominio=$i -f ../AWK/Estructura_DNS_Reg.awk ${DirConf}db.${i}.csv

	IFS=$(echo -en "\n\b")
	for a in $(cat /tmp/db.${i}.txt)
	do
		if [[ $a == $(cat ${DirDbDNS}db.$i | grep "$a") || $a == $(cat ${DirDbDNS}db.$(cat $ConfZonas | grep "$i" | cut -d "," -f2) | grep "$a") ]]
		then
			echo "$FechaLog Ya existe el registro $a en la zona $i" >> ../Salidas/DNS.sal
		else
			if [[ 1 = $(echo "$a" | grep -v "PTR" | wc -l)  ]]
				then
					echo "$a" >> ${DirDbDNS}db.$i
          echo "$FechaLog Añadimos el registro $a en ${DirDbDNS}db.$i" >> ../Salidas/DNS.sal
				else
					echo "$a" >> ${DirDbDNS}db.$(cat $ConfZonas | grep "$i" | cut -d "," -f2)
          echo "$FechaLog Añadimos el registro $a en ${DirDbDNS}db.$(cat $ConfZonas | grep "$i" | cut -d "," -f2)" >> ../Salidas/DNS.sal
				fi
		fi
	done
	IFS=$SaveIFS
done

service bind9 restart
