#!/bin/bash
# Script creado por FERLOPDIE Fernandez Lopez, Diego
#------------------------------------#
#            Variables               #
#------------------------------------#
source ../000_variables.sh


# Creamos la carpeta para los scripts de inicio de sesion
mkdir /netlogon

# Añadimos la ruta home en el inicio a los usuarios
echo "
# A compartición homes é especial, pois non precisa que se lle indique
# cal é o cartafol físico a compartir.
# O sistema xa se encarga de compartir de xeito automático a carpeta de
# cada usuario.
# Podese acceder a ela como \\dserver00\usuario

[homes]
        comment=Carpeta persoal
        writable = yes

# Indicamos cal é a ruta á carpeta física para poder ofrecer
# o recurso compartido comun
# O parámetro read list, non faría falla pois os permisos
# Xa están ben axustados fisicamente, co cal,
# Aínda que lle desemos permisos aos alumnos de escrbir
# no recurso compartido comun, non o poderían facer
# porque fisicamente /comun non lles deixa.
[comun]
        comment = Carpeta comun para todos os usuarios
        writeable = yes
        read list = @g-alum
        create mode = 775
        path = /comun
        directory mode = 775

#Recurso compartido para ser usado polo profesorado.
[alumnos]
        comment = Carpeta dos alumnos para que accedan os profesores
        read list = @g-profes
        path = /home/$DirUsers/alumnos

#Este recurso é para que se poidan executar os scripts de inicio e sesión nos clientes.
#Damos a posibilidade de escribir
#Pero so pode escribir o root, que é quen ten os permisos na carpeta física.
[netlogon]
        comment = Network Logon Service
        path = /netlogon
        writeable = yes " >> /etc/samba/smb.conf


# Reiniciamos el servicio samba
service smbd reload

# Copiamos el script a la carpeta netlogon
cp ../Configuracion/inicio.bat /netlogon

# Añadimos en la configuracion global cargar el script inicio.bat
sed -i "/^\[homes\]/ i\# Script de inicio de sesion para os clientes Windows do dominio\nlogon script = inicio.bat" /etc/samba/smb.conf


mkdir /netlogon/avisos

echo "Benvidos/as ao IES $(echo $DominioLDAP | cut -d. -f1)" > /netlogon/avisos/aviso_alumnos.html
chown :g-usuarios /netlogon -R #Recursivo

chmod 750 /netlogon -R #Recursivo
