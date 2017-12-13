#!/bin/bash
# Script creado por Fernández López, Diego
#######################################
#              Variables              #
#######################################
source ../000_variables.sh

#Crear esqueleto profes
#Por se executamos o script varias veces, comprobamos se xa existe o directorio
test -d $DirUsers/profes || mkdir -p $DirUsers/profes


#Crear esqueleto alumnos e comun
#Lemos o ficheiro cursos e procesamos cada curso
for CURSO in $(cat ../Configuracion/f00_cursos.txt)
do
	test -d $DirUsers/alumnos/$CURSO || mkdir -p $DirUsers/alumnos/$CURSO
	test -d $DirComun/$CURSO || mkdir -p $DirComun/$CURSO
done

test -d $DirComun/departamentos || mkdir -p $DirComun/departamentos


tree -l $DirUsers >> ../Salidas/NFS.sal
tree -l $DirComun >> ../Salidas/NFS.sal
