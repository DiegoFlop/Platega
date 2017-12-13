#!/bin/bash
# Script creado por FERLOPDIE Fernandez Lopez, Diego
#------------------------------------#
#            Variables               #
#------------------------------------#
source /mnt/floppy/000_variables.sh

for grupos in $(cat /mnt/floppy/LDAP/LDIF/groups.txt)
do
smbldap-groupmod -a $grupos
done

for smbuser in $(smbldap-userlist -u | cut -d"|" -f2)
do
smbldap-usermod -a $smbuser
done

for passsamba in $(smbldap-userlist -u | cut -d"|" -f2)
do
echo -e "abc123.\nabc123.\n" |smbpasswd -a $passsamba
done
