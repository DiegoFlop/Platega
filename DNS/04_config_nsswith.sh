#!/bin/bash
# Script creado por Fernández López, Diego
# En este script simplemente modificaremos la linea de hosts: del archivo /etc/nsswitch.conf
# lo que haremos sera comentar el actual y añadir posteriormente el nuestro.
# Si da la casualidad de que el archivo ya esta configurado no hará ningún cambia
# y nos añadirá una linea a nuestro archivo de log indicando cual fue el motivo.
######################################
#            Variables               #
######################################
source ../000_variables.sh
source ../Funciones/DNS_funciones.sh

if [[ $(cat /etc/nsswitch.conf | grep "^hosts:		files dns" | wc -l) = 1 ]]
	then
    echo "$FechaLog Ya existe hosts:		files dns configurado en /etc/nsswitch.conf" >> ../Salidas/DNS.sal
	else
  	sed -i "s/^hosts:/# hosts:/g" /etc/nsswitch.conf
  	sed -i "/# hosts:/ ahosts:\t\tfiles dns" /etc/nsswitch.conf
fi

# Reinicamos el servicio
service bind9 restart
