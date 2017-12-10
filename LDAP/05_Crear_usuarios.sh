#!/bin/bash
# Script creado por Fernández López, Diego
# En este script crearemos ls grupos del LDAP para ello cubrimos datos genericos
# añadiendo solo el nombre del grupo que se ecuentra en Configuracion/grupos_LDIF.txt
# Una vez añadidos y creado el ldif en /tmp los cargamos con ldapadd
######################################
#            Variables               #
######################################
source ../000_variables.sh
