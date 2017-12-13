#!/bin/bash
# Script creado por Fernández López, Diego
# En este script lo que haremos sera instalar y configurar LDAP en el cliente
# respondiendo las preguntas con la información con la que instalamos el LDAP
######################################
#            Variables               #
######################################
source ../000_variables.sh

# Instalamos el paquete de respuestas
apt install -y debconf-utils

echo "ldap-auth-config ldap-auth-config/bindpw password $LDAPpass
ldap-auth-config ldap-auth-config/rootbindpw password $LDAPpass
ldap-auth-config ldap-auth-config/rootbinddn string cn=$LDAProot,dc=$(echo $DominioLDAP | cut -d. -f1),dc=$(echo $DominioLDAP | cut -d. -f2)
ldap-auth-config ldap-auth-config/dblogin boolean false
ldap-auth-config ldap-auth-config/ldapns/ldap-server string ldap://$LDAPIp/
ldap-auth-config ldap-auth-config/override boolean true
ldap-auth-config ldap-auth-config/move-to-debconf boolean true
ldap-auth-config ldap-auth-config/ldapns/ldap_version select 3
ldap-auth-config ldap-auth-config/pam_password select md5
ldap-auth-config ldap-auth-config/dbrootlogin boolean true
ldap-auth-config ldap-auth-config/ldapns/base-dn string dc=$(echo $DominioLDAP | cut -d. -f1),dc=$(echo $DominioLDAP | cut -d. -f2)
libpam-runtime libpam-runtime/profiles multiselect unix, ldap, systemd, gnome-keyring
ldap-auth-config ldap-auth-config/binddn string cn=proxyuser,dc=$(echo $DominioLDAP | cut -d. -f1),dc=$(echo $DominioLDAP | cut -d. -f2)" | debconf-set-selections

apt install -y libpam-ldapd


# Creamos el archivo de respuestas para el nslcd de LDAP
echo "nslcd nslcd/ldap-uris string ldap://$LDAPIp/" | debconf-set-selections
echo "nslcd nslcd/ldap-binddn string $LDAProot" | debconf-set-selections
echo "nslcd nslcd/ldap-bindpw password $LDAPpass" | debconf-set-selections
echo "nslcd nslcd/ldap-base string dc=$(echo $DominioLDAP | cut -d. -f1),dc=$(echo $DominioLDAP | cut -d. -f2)" | debconf-set-selections
echo "nslcd nslcd/ldap-auth-type select none" | debconf-set-selections
echo "nslcd nslcd/ldap-starttls boolean false" | debconf-set-selections
echo "libnss-ldapd libnss-ldapd/clean_nsswitch boolean false" | debconf-set-selections
echo "libnss-ldapd:amd64 libnss-ldapd/clean_nsswitch boolean false" | debconf-set-selections
echo "libnss-ldapd libnss-ldapd/nsswitch multiselect passwd, group, shadow, hosts" | debconf-set-selections
echo "libnss-ldapd:amd64 libnss-ldapd/nsswitch multiselect passwd, group, shadow, hosts" | debconf-set-selections
apt install -y nslcd
dpkg-reconfigure -f noninteractive nslcd

echo "$FechaLog $(getent passwd)" >> ../Salidas/Ubuntu_cliente.sal
echo "$FechaLog $(getent group)" >> ../Salidas/Ubuntu_cliente.sal
