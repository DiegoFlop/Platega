#!/bin/bash
# Script creado por FERLOPDIE Fernandez Lopez, Diego
#------------------------------------#
#            Variables               #
#------------------------------------#
source ../000_variables.sh


# Copiamos el skel en la ruta que indicamos anteriormente en la configuracion de SAMBA
cp -r $DirConf/skel_ubuntu /etc/

# Creamos un backup del LDAP
slapcat -l backup.ldif

# Hacemos unas comprobaciones:
ldapsearch -x -LLL -s one -b dc=$(echo $DominioLDAP | cut -d. -f1),dc=$(echo $DominioLDAP | cut -d. -f2) dn >> ../Salidas/SAMBA3.sal
getent passwd | tail -n 15 >> ../Salidas/SAMBA3.sal
getent group | tail -n 16 >> ../Salidas/SAMBA3.sal
