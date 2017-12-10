#!/bin/bash
# Script creado por Fernández López, Diego
# En este script crearemos las ous que usaremos en nuestro dominio de LDAP
# Para ello primero configuramos el archivo ous_LDIF.txt.
# Seguidamente hacemos una copia de la variable IFS
# Eliminamos el archivo que pueda haber en nuestra carpeta temporal
# Seguidamente hacemos un for a nuestro archivo de configuración en el que
# le cambiamos el IFS para no tener problemas y hacemos una serie de comprobaciones
# La comprobación es ver de cuantas palabras esta compuesta cada linea dependiendo del
# resultado ejecutaremos un echo u otro...
# Finalmente cargamos nuestro LDIF y devolvemos el IFS a su valor original.
######################################
#            Variables               #
######################################
source ../000_variables.sh
source ../Funciones/LDAP_funciones.sh

# Guardamos la variable IFS
SaveIFS=$IFS

# Eliminamos el archivo /tmp/ous.ldif
rm /tmp/ous.ldif

############################################################################
# Advertimos de que configuren las OU antes de continuar con la Configuración
read -rsp $'Por favor antes de continuar asegurese de tener configurado el archivo
 /Configuracion/ous_LDIF.txt para ello puede conectarse de forma remota por SSH,
 con Notepad, otra terminal una vez que esté seguro de que esta configurado pulse ENTER...\n'

for i in $(cat  ../Configuracion/ous_LDIF.txt)
do
IFS=$(echo -en "\n\b")

if [ $(echo $i | wc -w) = 1 ]
	then
  echo "dn: ou=$(echo $i | cut -d" " -f1),dc=$(echo $DominioLDAP | cut -d. -f1),dc=$(echo $DominioLDAP | cut -d. -f2)
  objectClass: organizationalUnit
  ou: $(echo $i | cut -d" " -f1)
  " >> /tmp/ous.ldif
	else
	if [ $(echo $i | wc -w) = 2 ]
		then
		echo "dn: ou=$(echo $i | cut -d" " -f1),ou=$(echo $i | cut -d" " -f2),dc=$(echo $DominioLDAP | cut -d. -f1),dc=$(echo $DominioLDAP | cut -d. -f2)
		  objectClass: organizationalUnit
		  ou: $(echo $i | cut -d" " -f1)
		  " >> /tmp/ous.ldif
		else
		if [ $(echo $i | wc -w) = 3 ]
			then
			echo "dn: ou=$(echo $i | cut -d" " -f1),ou=$(echo $i | cut -d" " -f2),ou=$(echo $i | cut -d" " -f3),dc=$(echo $DominioLDAP | cut -d. -f1),dc=$(echo $DominioLDAP | cut -d. -f2)
			  objectClass: organizationalUnit
			  ou: $(echo $i | cut -d" " -f1)
			  " >> /tmp/ous.ldif
		fi
    fi
  fi
done

# Devolvemos el valor original a la variable
IFS=$SaveIFS

# Añadimos las ous a LDAP
ldapadd -D cn=$(echo $LDAProot),dc=$(echo $DominioLDAP | cut -d. -f1),dc=$(echo $DominioLDAP | cut -d. -f2) -w $LDAPpass -f /tmp/ous.ldif -c
