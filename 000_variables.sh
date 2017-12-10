#!/bin/bash
# Script creado por Fernández López, Diego
# Lo primero que haremos será crear un archivo con las variables que necesitaremos
# a lo largo del curso.
# En este script intentaremos disponer de la mayor cantidad de variables "globales"
# para que a la hora de tener que realizar modificaciones solo debamos modificar
# los valores de las variables de este archivo.

################
#    COMUNES   #
################
Fecha=`date +"%d-%m-%Y"`
FechaLog=`date +"A las %T del %d-%m-%Y:=>"`
Floopy=/mnt/floppy/
DirConf=/mnt/floppy/Configuracion/

#################
#    SERVIDOR   #
#################
CurrentNameServer=
NewNameServer=
TarjetaServer=enp0s3
ServerIp=172.16.5.10
ServerMask=24
ServerGate=172.16.5.1
ServerDns1=172.16.5.10
ServerDns2=172.16.0.58
ServerDns3=213.60.205.175
ServerDomain=iescalquera.local

#######################
#    CLIENTE UBUNTU   #
#######################


############
#    DNS   #
############

DirConfDNS=/etc/bind/
DirDbDNS=/var/cache/bind/
ConfZonas=/mnt/floppy/Configuracion/zonasDNS.csv

#############
#    DDNS   #
#############



#############
#    DHCP   #
#############
ConfDHCP=/etc/dhcp/dhcpd.conf
ConfDefDHCP=/etc/default/isc-dhcp-server
AmbitosDHCP=/mnt/floppy/Configuracion/ambitos.csv
ReservasDHCP=/mnt/floppy/Configuracion/reservas.csv
#############
#    LDAP   #
#############
DEBIAN_FRONTEND=noninteractive
LDAPIp="172.16.5.10"
LDAProot="admin"
LDAPpass="abc123."
DominioLDAP="iesmuralla.local"
GIDinicial=9999
############
#    NFS   #
############



################
#    SAMBA 3   #
################


################
#    SAMBA 4   #
################



###############
#    Cuotas   #
###############
