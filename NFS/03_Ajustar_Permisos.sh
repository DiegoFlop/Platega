#!/bin/bash
# Script creado por Fernández López, Diego
#######################################
#              Variables              #
#######################################
source ../000_variables.sh

#Cartafol /home/iescalquera
chown root:g-usuarios $DirUsers 	# Cambiar grupo propietario
chmod 750 $DirUsers		# Axustar permisos

#Cartafol profes
chown root:g-profes $DirUsers/profes
chmod 750 $DirUsers/profes


#Cartafol alumnos
chown root:g-usuarios $DirUsers/alumnos
chmod 750 $DirUsers/alumnos

#Cartafoles cursos
for CURSO in $(cat f00_cursos.txt)
do
	chown root:g-usuarios $DirUsers/alumnos/$CURSO
	chmod 750 $DirUsers/alumnos/$CURSO
done


#Cartafol comun
chown root:g-usuarios $DirComun
chmod 750 $DirComun


#Subcartafol departamentos

chown root:g-profes $DirComun/departamentos
chmod 770 $DirComun/departamentos



#Subcartafoles cursos
# O participante no curso a vista do esquema de permisos
# e do exemplo de arriba debe ser quen de axustar
# os permisos de /comun/<cursos>
# Ollo!!!!! nas subcarpetas co grupo others.
# Unha pista para o grupo propietario dos cursos: g-"$CURSO"-profes
#
#IMPORTANTE: o que se lle engada ao script, debe valer para futuros crecementos en curso: asir1, asir2, etc.
#Con so dar de alta no ficheiro f00_cursos.txt os cursos non deberamos tocar nada no presente script.

for CURSO in $(cat f00_cursos.txt)
do
	chown root:g-$CURSO-profes $DirComun/$CURSO
	chmod 775 $DirComun/$CURSO
done
