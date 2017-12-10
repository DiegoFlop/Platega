#!/bin/bash
# Script creado por Fernández López, Diego
#######################################
#              Variables              #
#######################################
source ../000_variables.sh


#Lembrar que  cada usuario ten o seguinte formato
# Un/unha profe  -> sol:x:10000:10000:Profe - Sol Lua:/home/iescalquera/profes/sol:/bin/bash
# Un/unha alumna -> mon:x:10002:10000:DAM1 Mon Mon:/home/iescalquera/alumnos/dam1/mon:/bin/bash

# Observar que posicion ocupan os campos e que estan separados por :

# Imos extraer con awk dos usuarios con ID (campo 3) entre 10000 e 60000 os campos
# Usuario (campo 1) e home (campo 6)
# Deste campo (home) imos extraer o grupo ao que pertence o usuario
# Neste caso o separador de campos e /, e o grupo esta no 4ยบ campo.


#Volcamos todolos usuarios (locais e ldap) do sistema a un ficheiro
getent passwd > /tmp/usuarios.txt


#Extraemos os campos anteriores
for USUARIO in $( awk -F: '$3>=10000 && $3<60000  {print $1":"$6}' /tmp/usuarios.txt )
do
	#USUARIO vai ter o seguinte formato
	# sol:/home/iescalquera/profes/sol

 	NOME_USUARIO=$( echo $USUARIO | awk -F: '{print $1}')
 	HOME_USUARIO=$( echo $USUARIO | awk -F: '{print $2}')
	GRUPO_GLOBAL_USUARIO=$( echo $HOME_USUARIO | awk -F/ '{print $4}')

	#Creamos a carpeta persoal do usuario/a
	test -d $HOME_USUARIO || mkdir -p $HOME_USUARIO

 	#Copiamos o contido de skel_ubuntu (ocultos incluidos, -a) a carpeta persoal do usuario/a
	cp -a ../Configuracion/skel_ubuntu/\. $HOME_USUARIO

	#Comprobamos se o usuario/a e un profe
	if [ $GRUPO_GLOBAL_USUARIO = "profes" ]
	then
		#Se e un profe deixamos entrar so a ese profe na sua carpeta persoal
		chown -R $NOME_USUARIO:g-usuarios $HOME_USUARIO
		chmod -R 700 $HOME_USUARIO
	else
		#Se e un alumno o campo 5 do home coincide con parte do nome do grupo ao que pertence
		GRUPO_ALUMNO=$( echo $HOME_USUARIO |awk -F/ '{print $5}')

		#Se e un alumno deixamos entrar en modo lectura execucion aos profes dese curso
		# en modo recursivo
		chown -R $NOME_USUARIO:g-$GRUPO_ALUMNO-profes $HOME_USUARIO
		chmod -R 750 $HOME_USUARIO
	fi
done

rm /tmp/usuarios.txt
