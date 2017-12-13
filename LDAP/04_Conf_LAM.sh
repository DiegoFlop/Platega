#!/bin/bash
# Script creado por Fernández López, Diego
# En este script lo que haremos sera sustituir el archivo de configuración de LAM
# Por la configuración correspondiente a nuestro dominio.
######################################
#            Variables               #
######################################
source ../000_variables.sh

# comentamos y cambiamos la linea del admins
sed -i 's/^admins/####&/' /usr/share/ldap-account-manager/config/lam.conf
sed -i "/^####admins/a\admins: cn=$(echo $LDAProot),dc=$(echo $DominioLDAP | cut -d. -f1),dc=$(echo $DominioLDAP | cut -d. -f2)" /usr/share/ldap-account-manager/config/lam.conf

# comentamos y cambiamos la linea del treesuffix
sed -i 's/^treesuffix/####&/' /usr/share/ldap-account-manager/config/lam.conf
sed -i "/^####treesuffix/a\treesuffix: dc=$(echo $DominioLDAP | cut -d. -f1),dc=$(echo $DominioLDAP | cut -d. -f2)" /usr/share/ldap-account-manager/config/lam.conf

# comentamos y cambiamos la linea del defaultLanguage
sed -i 's/^defaultLanguage/####&/' /usr/share/ldap-account-manager/config/lam.conf
sed -i "/^####defaultLanguage/a\defaultLanguage: es_ES\.utf8" /usr/share/ldap-account-manager/config/lam.conf

# comentamos y cambiamos la linea del types: suffix_user
sed -i 's/^types: suffix_user/####&/' /usr/share/ldap-account-manager/config/lam.conf
sed -i "/^####types: suffix_user/a\types: suffix_user: ou=usuarios,dc=$(echo $DominioLDAP | cut -d. -f1),dc=$(echo $DominioLDAP | cut -d. -f2)" /usr/share/ldap-account-manager/config/lam.conf

# comentamos y cambiamos la linea del types: modules_user
sed -i 's/^types: modules_user/####&/' /usr/share/ldap-account-manager/config/lam.conf
sed -i "/^####types: modules_user/a\types: modules_user: inetOrgPerson,posixAccount,shadowAccount,sambaSamAccount" /usr/share/ldap-account-manager/config/lam.conf

# comentamos y cambiamos la linea del types: suffix_group
sed -i 's/^types: suffix_group/####&/' /usr/share/ldap-account-manager/config/lam.conf
sed -i "/^####types: suffix_group/a\types: suffix_group: ou=grupos,dc=$(echo $DominioLDAP | cut -d. -f1),dc=$(echo $DominioLDAP | cut -d. -f2)" /usr/share/ldap-account-manager/config/lam.conf

# comentamos y cambiamos la linea del types: modules_group
sed -i 's/^types: modules_group/####&/' /usr/share/ldap-account-manager/config/lam.conf
sed -i "/^####types: modules_group/a\types: modules_group: posixGroup,sambaGroupMapping" /usr/share/ldap-account-manager/config/lam.conf

echo "
serverDisplayName:

# enable TLS encryption
useTLS: no

# follow referrals
followReferrals: false

# paged results
pagedResults: false

# time zone
timeZone: Europe/Madrid
scriptUserName:
scriptSSHKey:
scriptSSHKeyPassword:

# Access level for this profile.
accessLevel: 100

# Login method.
loginMethod: list

# Search suffix for LAM login.
loginSearchSuffix: dc=$(echo $DominioLDAP | cut -d. -f1),dc=$(echo $DominioLDAP | cut -d. -f2)

# Search filter for LAM login.
loginSearchFilter: uid=%USER%

# Bind DN for login search.
loginSearchDN:

# Bind password for login search.
loginSearchPassword:

# HTTP authentication for LAM login.
httpAuthentication: false

# Password mail from
lamProMailFrom:

# Password mail reply-to
lamProMailReplyTo:

# Password mail is HTML
lamProMailIsHTML: false

# Allow alternate address
lamProMailAllowAlternateAddress: true

jobsBindPassword:
jobsBindUser:
jobsDatabase:
jobsDBHost:
jobsDBPort:
jobsDBUser:
jobsDBPassword:
jobsDBName:
jobToken: 196466195914

pwdResetAllowSpecificPassword: true
pwdResetAllowScreenPassword: true
pwdResetForcePasswordChange: true
pwdResetDefaultPasswordOutput: 2
types: filter_user:
types: customLabel_user:
types: filter_group:
types: customLabel_group:
types: hidden_user:
types: hidden_group:
types: hidden_host:
types: suffix_host: ou=maquinas,dc=$(echo $DominioLDAP | cut -d. -f1),dc=$(echo $DominioLDAP | cut -d. -f2)
types: attr_host: #cn;#description;#uidNumber;#gidNumber
types: filter_host:
types: customLabel_host:
types: modules_host: account,posixAccount,sambaSamAccount
tools: tool_hide_toolTests: false
tools: tool_hide_toolPDFEditor: false
tools: tool_hide_toolMultiEdit: false
tools: tool_hide_toolProfileEditor: false
tools: tool_hide_toolOUEditor: false
tools: tool_hide_toolServerInformation: false
tools: tool_hide_toolSchemaBrowser: false
tools: tool_hide_toolFileUpload: false
types: hidden_smbDomain:
types: suffix_smbDomain: dc=$(echo $DominioLDAP | cut -d. -f1),dc=$(echo $DominioLDAP | cut -d. -f2)
types: attr_smbDomain: #sambaDomainName;#sambaSID
types: filter_smbDomain:
types: customLabel_smbDomain:
types: modules_smbDomain: sambaDomain
" >> /usr/share/ldap-account-manager/config/lam.conf
