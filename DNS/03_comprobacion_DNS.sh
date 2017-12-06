#!/bin/bash
# Script creado por Fernández López, Diego
# En este script vamos a utilizar una herramienta para comprobar si nuestros archivos
# de configuración del DNS están correctos. Sera un script muy sencillo. Podríamos
# revisar el log para comprobar si todo ha ido correctamente pero con este Script
# nos centraremos en las zonas que realmente son los archivos que tocamos más en
# profundidad.


######################################
#            Variables               #
######################################
source ../000_variables.sh
source ../Funciones/DNS_funciones.sh


for i in $(cat $ConfZonas | grep -v "#" | cut -d"," -f1)
do
    named-checkzone $i ${DirDbDNS}db.$i | tee >> ../Salidas/DNS.sal
    # El símbolo backslash "\" utilizado al final de la linea es meramente por organización
    # ya que con el le indicamos a la shell que la siguiente linea pertenece a la misma.
    named-checkzone ${iprev[2]}.${iprev[1]}.${iprev[0]}.in-addr.arpa \
    ${DirDbDNS}db.$(cat $ConfZonas | grep  "$i" | cut -d"," -f2) | tee >> ../Salidas/DNS.sal
done
