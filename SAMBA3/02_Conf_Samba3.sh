#!/bin/bash
# Script creado por Fernández López, Diego
#######################################
#              Variables              #
#######################################
source ../000_variables.sh

# Creamo una copia del archivo de configuracion original
mv /etc/samba/smb.conf /etc/samba/smb.conf.orixinal

cp ../Configuracion/smb.conf /etc/samba/smb.conf


# comentamos y cambiamos la linea de workgroup
sed -i 's/^workgroup =/####&/' /etc/samba/smb.conf
sed -i "/^####workgroup =/a\workgroup = $(echo $DominioLDAP | cut -d. -f1 |tr [[:lower:]] [[:upper:]])" /etc/samba/smb.conf

# comentamos y cambiamos la linea de netbios
sed -i 's/^netbios/####&/' /etc/samba/smb.conf
sed -i "/^####netbios/a\netbios name = $(echo $NewNameServer | cut -d. -f1)" /etc/samba/smb.conf

# comentamos y cambiamos la linea de server string
sed -i 's/^server string/####&/' /etc/samba/smb.conf
sed -i "/^####server string/a\server string = Servidor de dominio do $(echo $DominioLDAP | cut -d. -f1)" /etc/samba/smb.conf

# comentamos y cambiamos la linea de ldap suffix
sed -i 's/^ldap suffix/####&/' /etc/samba/smb.conf
sed -i "/^####ldap suffix/a\ldap suffix = dc=$(echo $DominioLDAP | cut -d. -f1),dc=$(echo $DominioLDAP | cut -d. -f2)" /etc/samba/smb.conf

# comentamos y cambiamos la linea de ldap admin dn
sed -i 's/^ldap admin dn/####&/' /etc/samba/smb.conf
sed -i "/^####ldap admin dn/a\ldap admin dn = cn=$(echo $LDAProot),dc=$(echo $DominioLDAP | cut -d. -f1),dc=$(echo $DominioLDAP | cut -d. -f2)" /etc/samba/smb.conf



# Para subministrar a clave usaremos o comando smbpasswd:
smbpasswd -w $PassSMB

# E reiniciamos o servidor samba para activar a configuración:
service smbd restart
