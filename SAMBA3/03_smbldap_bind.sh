#!/bin/bash
# Script creado por Fernández López, Diego
#######################################
#              Variables              #
#######################################
source ../000_variables.sh

#Copiamos o outro ficheiro de configuración:
cp /usr/share/doc/smbldap-tools/examples/smbldap_bind.conf /etc/smbldap-tools/

#Axustar permisos
chmod 600 /etc/smbldap-tools/smbldap_bind.conf

# Comentamos las lineas originales:
sed -i 's/^slaveDN.*/#&/' /etc/smbldap-tools/smbldap_bind.conf
sed -i 's/^slavePw.*/#&/' /etc/smbldap-tools/smbldap_bind.conf
sed -i 's/^masterDN.*/#&/' /etc/smbldap-tools/smbldap_bind.conf
sed -i 's/^masterPw.*/#&/' /etc/smbldap-tools/smbldap_bind.conf


# Ahora insertamos seguidamente las lineas que nos interesan:
sed -i "/#slaveDN/a\slaveDN=\"cn=$LDAProot,dc=$(echo $DominioLDAP | cut -d. -f1),dc=$(echo $DominioLDAP | cut -d. -f2)\"" /etc/smbldap-tools/smbldap_bind.conf
sed -i "/#slavePw/a\slavePw=\"$LDAPpass\"" /etc/smbldap-tools/smbldap_bind.conf
sed -i "/#masterDN/a\masterDN=\"cn=$LDAProot,dc=$(echo $DominioLDAP | cut -d. -f1),dc=$(echo $DominioLDAP | cut -d. -f2)\"" /etc/smbldap-tools/smbldap_bind.conf
sed -i "/#masterPw/a\masterPw=\"$LDAPpass\"" /etc/smbldap-tools/smbldap_bind.conf
