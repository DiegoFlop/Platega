#!/bin/bash
# Script creado por Fernández López, Diego
#
source 000_variables.sh
#
# Este script lo utilizaremos para cambiar el nombre de nuestro servidor debian v9
# tanto del archivo "/etc/hostname" como del archivo "/etc/hosts"
# una vez realizado modificaremos el archivo /proc/sys/kernel/hostname donde indicaremos
# también el nuevo nombre del equipo (para evitar reiniciar el servidor)
# Lo que haremos será primero leer el nombre actual del archivo /etc/hostname
# seguidamente buscaremos y sustituiremos ese nombre del archivo /etc/hosts
# Hecho lo anterior el siguiente paso es cambiar el nombre del archivo /etc/hostname
# Por último modificamos /proc/sys/kernel/hostname para activar el nuevo nombre
# Ejecutamos el comando "bash" para que actualice la información en la sesión actual
sed -i 's/'$CurrentNameServer'\b/'$NewNameServer'/gi' /etc/hosts
echo $NewNameServer > /proc/sys/kernel/hostname
echo $NewNameServer > /etc/hostname
bash
