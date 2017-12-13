#!/bin/bash
# Script creado por Fernández López, Diego
#######################################
#              Variables              #
#######################################
source ../000_variables.sh

# Instalamos samba
apt install -y samba smbldap-tools winbind smbclient samba-testsuite samba-common-bin samba-common registry-tools libsmbclient libpam-winbind

# Extraemos la el schema de SAMBA
zcat /usr/share/doc/samba/examples/LDAP/samba.schema.gz > /etc/ldap/schema/samba.schema

# Creamos una carpeta en tmp
mkdir /tmp/ldif


slaptest -f ../Configuracion/schema_convert.conf -F /tmp/ldif

# Copiamos el archivo samba.schema
# Copiamos o ficheiro samba.ldif
cp "/tmp/ldif/cn=config/cn=schema/cn={4}samba.ldif" "/etc/ldap/slapd.d/cn=config/cn=schema"
chown openldap: '/etc/ldap/slapd.d/cn=config/cn=schema/cn={4}samba.ldif'
service slapd restart


# Cargamos el fichero de indices:
ldapadd -Y EXTERNAL -H ldapi:/// -f ../Configuracion/samba_indices_1.ldif


#modificamos los indices que ya existen
ldapadd -Y EXTERNAL -H ldapi:/// -f ../Configuracion/samba_indices_2.ldif
