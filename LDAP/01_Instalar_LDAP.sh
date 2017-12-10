#!/bin/bash
# Script creado por Fernández López, Diego
# en este script vamos a instalar el servidor LDAP completamente desatendio.
# para ello instalaremos el paquete debconf-utils
# Una vez instalado crearemos las respuestas a las preguntas de LDAP
# Al instalar LDAP durante la instalación solo pide la contraseña del roor de
# LDAP, posteriormente reconfiguraremos el paquete de LDAP en el cual respoderemos
# mas preguntas...
# Seguidamente instalaremos otros paquetes que nos ayudaran a configurar de
# forma grafica LDAP.
# Por ultimo configuramos los paquetes de actualización y conexión contra LDAP.
######################################
#            Variables               #
######################################
source ../000_variables.sh

# Instalamos el programa de respuestas
apt install debconf-utils -y
# Creamos el archivo de respuestas para LDAP

echo "slapd slapd/root_password password $LDAPpass" | debconf-set-selections
echo "slapd slapd/root_password_again password $LDAPpass" | debconf-set-selections
echo "slapd slapd/password1 password $LDAPpass" | debconf-set-selections
echo "slapd slapd/password2 password $LDAPpass" | debconf-set-selections
# Instalamos LDAP
apt install -y slapd ldap-utils
# Creamos el archivo de respuestas para la configuracion de LDAP
echo "slapd slapd/root_password password $LDAPpass" | debconf-set-selections
echo "slapd slapd/root_password_again password $LDAPpass" | debconf-set-selections
echo "slapd slapd/no_configuration boolean false" | debconf-set-selections
echo "slapd slapd/domain string $DominioLDAP" | debconf-set-selections
echo "slapd shared/organization string $DominioLDAP" | debconf-set-selections
echo "slapd slapd/password1 password $LDAPpass" | debconf-set-selections
echo "slapd slapd/password2 password $LDAPpass" | debconf-set-selections
echo "slapd slapd/backend select MDB" | debconf-set-selections
echo "slapd slapd/purge_database boolean false" | debconf-set-selections
echo "slapd slapd/allow_ldap_v2 boolean false" | debconf-set-selections
echo "slapd slapd/move_old_database boolean true" | debconf-set-selections

# Reconfiguramos LDAP
dpkg-reconfigure -f noninteractive slapd

# Instalamos LDAP y progamas complementarios
apt install -y ldapscripts ldap-account-manager tree
apt install -y php-xml php-zip
/etc/init.d/apache2 restart
#apt install jxplorer -y

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

# Iniciamos el servicio LDAP
/etc/init.d/slapd restart
/etc/init.d/nslcd restart
/etc/init.d/nscd restart
