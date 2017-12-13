#!/bin/bash
##!/bin/bash
# Script creado por Fernández López, Diego
#######################################
#              Variables              #
#######################################
source ../000_variables.sh

# Leemos que versión de Sistema Operativo tenemos:
version=`cat /etc/issue`

if  [[ $version = "Debian GNU/Linux 7 \n \l" ]];
	then
		cp /etc/apt/sources.list /etc/apt/sources.list.$Fecha.bak
		cat Repositorios/repo_debian7.txt > /etc/apt/sources.list

  	elif [[ $version = "Debian GNU/Linux 8 \n \l" ]];
  		then
  			cp /etc/apt/sources.list /etc/apt/sources.list.$Fecha.bak
  			cat Repositorios/repo_debian8.txt > /etc/apt/sources.list

  	elif [[ $version = "Debian GNU/Linux 9 \n \l" ]];
  		then
  			cp /etc/apt/sources.list /etc/apt/sources.list.$Fecha.bak
  			cat Repositorios/repo_debian9.txt > /etc/apt/sources.list

	else
		echo "Es una versión muy antigua"
fi
apt update
