#!/bin/bash
# Script creado por FERLOPDIE Fernandez Lopez, Diego
#------------------------------------#
#            Variables               #
#------------------------------------#
source /mnt/floppy/000_variables.sh

#Descomprimimos un dos ficheiros de configuración
zcat /usr/share/doc/smbldap-tools/examples/smbldap.conf.gz >  /etc/smbldap-tools/smbldap.conf


# comentamos y cambiamos la linea del SID
sed -i 's/^SID/####&/' /etc/smbldap-tools/smbldap.conf
sed -i "/^####SID/a\SID=\"$( net getlocalsid |cut -d: -f2 | sed 's/^ //')\"" /etc/smbldap-tools/smbldap.conf

# comentamos y cambiamos la linea de sambaDomain
sed -i 's/^sambaDomain=/#&/' /etc/smbldap-tools/smbldap.conf
sed -i "/^#sambaDomain=/a\sambaDomain=\"$(echo $DominioLDAP|tr [[:lower:]] [[:upper:]] | cut -d. -f1)\"" /etc/smbldap-tools/smbldap.conf

# comentamos y cambiamos la linea de slaveLDAP
sed -i 's/^slaveLDAP=/####&/' /etc/smbldap-tools/smbldap.conf
sed -i "/^####slaveLDAP=/a\slavePort=\"389\"" /etc/smbldap-tools/smbldap.conf

# comentamos y cambiamos la linea de masterLDAP
sed -i 's/^masterLDAP=/####&/' /etc/smbldap-tools/smbldap.conf
sed -i "/^####masterLDAP=/a\masterPort=\"389\"" /etc/smbldap-tools/smbldap.conf

# comentamos y cambiamos la linea de ldapTLS
sed -i 's/^ldapTLS=/####&/' /etc/smbldap-tools/smbldap.conf
# Insertamos justo despues las lineas de ldapSSl
sed -i "/^####ldapTLS=/a\ \n# Use SSL for LDAP\n# If set to 1, this option will use SSL for connection\n# (standard port for ldaps is 636)\n# If not defined, parameter is set to "0"\nldapSSL=\"0\"" /etc/smbldap-tools/smbldap.conf

# comentamos y cambiamos la linea de suffix
sed -i 's/^suffix=/####&/' /etc/smbldap-tools/smbldap.conf
sed -i "/^####suffix=/a\suffix=\"dc=$(echo $DominioLDAP | cut -d. -f1),dc=$(echo $DominioLDAP | cut -d. -f2)\"" /etc/smbldap-tools/smbldap.conf


# comentamos y cambiamos la linea de usersdn
sed -i 's/^usersdn=/####&/' /etc/smbldap-tools/smbldap.conf
sed -i "/^####usersdn=/a\usersdn=\"ou=usuarios,\${suffix}\"" /etc/smbldap-tools/smbldap.conf

# comentamos y cambiamos la linea de computersdn
sed -i 's/^computersdn=/####&/' /etc/smbldap-tools/smbldap.conf
sed -i "/^####computersdn=/a\computersdn=\"ou=maquinas,\${suffix}\"" /etc/smbldap-tools/smbldap.conf

# comentamos y cambiamos la linea de groupsdn
sed -i 's/^groupsdn=/####&/' /etc/smbldap-tools/smbldap.conf
sed -i "/^####groupsdn=/a\groupsdn=\"ou=grupos,\${suffix}\"" /etc/smbldap-tools/smbldap.conf

# comentamos y cambiamos la linea de userHome
sed -i 's/^userHome=/####&/' /etc/smbldap-tools/smbldap.conf
sed -i "/^####userHome=/a\userHome=\"$DirUsers\/%U\"" /etc/smbldap-tools/smbldap.conf

# comentamos y cambiamos la linea de userGecos
sed -i 's/^userGecos=/####&/' /etc/smbldap-tools/smbldap.conf
sed -i "/^####userGecos=/a\userGecos=\"Usuario de $(echo $DominioLDAP | cut -d. -f1)\"" /etc/smbldap-tools/smbldap.conf

# comentamos y cambiamos la linea de skeletonDir
sed -i 's/^skeletonDir=/####&/' /etc/smbldap-tools/smbldap.conf
sed -i "/^####skeletonDir=/a\skeletonDir=\"\/etc\/skel_ubuntu\"" /etc/smbldap-tools/smbldap.conf

# comentamos y cambiamos la linea de userSmbHome
sed -i 's/^userSmbHome=/####&/' /etc/smbldap-tools/smbldap.conf
sed -i "/^####userSmbHome=/a\userSmbHome=\"\/\/$(echo ${NombreServer}.$ServerDomain | cut -d. -f1)\/%U\"" /etc/smbldap-tools/smbldap.conf

# comentamos y cambiamos la linea de userProfile
sed -i 's/^userProfile=/####&/' /etc/smbldap-tools/smbldap.conf

# comentamos y cambiamos la linea de userHomeDrive
sed -i 's/^userHomeDrive=/####&/' /etc/smbldap-tools/smbldap.conf
sed -i "/^####userHomeDrive=/a\userHomeDrive=\"$UserHomeDrive\"" /etc/smbldap-tools/smbldap.conf

# comentamos y cambiamos la linea de userScript
sed -i 's/^userScript=/####&/' /etc/smbldap-tools/smbldap.conf
sed -i "/^####userScript=/a\userScript=\"$UserScript\"" /etc/smbldap-tools/smbldap.conf

# comentamos y cambiamos la linea de mailDomain
sed -i 's/^mailDomain=/####&/' /etc/smbldap-tools/smbldap.conf
sed -i "/^####mailDomain=/a\mailDomain=\"$MailDomain\"" /etc/smbldap-tools/smbldap.conf
