#!/bin/bash
# Script creado por Fernández López, Diego
# En este script crearemos ls grupos del LDAP para ello cubrimos datos genericos
# añadiendo solo el nombre del grupo que se ecuentra en Configuracion/grupos_LDIF.txt
# Una vez añadidos y creado el ldif en /tmp los cargamos con ldapadd
######################################
#            Variables               #
######################################
source ../000_variables.sh


############################################################################
read -rsp $'Por favor antes de continuar asegurese de tener configurado el archivo
de la carpeta de /Configuracion/grupos_LDIF.txt para ello puede conectarse de forma
remota por SSH, con Notepad, otra terminal una vez que esté seguro de que esta
configurado pulse ENTER...\n'

for i in $(cat ../Configuracion/grupos_LDIF.txt)
do
GIDinicial=$((GIDinicial + 1))
echo "# cn=$i, ou=grupos, $(echo $DominioLDAP | cut -d. -f1).$(echo $DominioLDAP | cut -d. -f2)
dn: cn=$i,ou=grupos,dc=$(echo $DominioLDAP | cut -d. -f1),dc=$(echo $DominioLDAP | cut -d. -f2)
objectClass: posixGroup
cn: $i
gidNumber: $GIDinicial
" >> /tmp/groups.ldif

done

ldapadd -D cn=$(echo $LDAProot),dc=$(echo $DominioLDAP | cut -d. -f1),dc=$(echo $DominioLDAP | cut -d. -f2) -w $LDAPpass -f /tmp/groups.ldif -c &>>   ../Salidas/LDAP.sal
