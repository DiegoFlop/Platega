#!/bin/bash
# Script creado por Fernández López, Diego
# En este script instalamos las cuotas. Vamos a aplicar las plantillas creadas anteriormente

######################################
#            Variables               #
######################################
source ../000_variables.sh

#SCRIPT PARA ASIGNAR COTAS AOS USUARIOS.

#Lembrar que  cada usuario ten o seguinte formato
# Un/unha profe  -> sol:x:10000:10000:Profe - Sol Lua:/home/iescalquera/profes/sol:/bin/bash
# Un/unha alumna -> mon:x:10002:10000:DAM1 Mon Mon:/home/iescalquera/alumnos/dam1/mon:/bin/bash

# Observar que posición ocupan os campos e que están separados por :

# Imos etraer con awk dos usuarios con ID (campo 3) entre 10000 e 60000 o campo
# Usuario (campo 1)


#Volcamos tódolos usuarios (locais e ldap) do sistema a un ficheiro
getent passwd>usuarios.txt


#Extraemos o campo usuario
for USUARIO in $( awk -F: '$3>=10000 && $3<60000  {print $1}' usuarios.txt )
do
	#USUARIO vai ter o seguinte formato
	# sol

	#Comprobamos se o usuario/a é un profe
	if ( groups $USUARIO | grep profes )
	then
		#Copiamos cota do prototipo profe ao usuario profe
		edquota -p profe $USUARIO
	else
		#Copiamos cota do prototipo alumno ao usuario alumno/a
		edquota -p alumno $USUARIO
	fi
done

rm usuarios.txt
