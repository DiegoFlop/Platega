#!/bin/bash
# Script creado por Fernández López, Diego
# En este script configuremos nuestro servidor DHCP y DNS para que trabajen conjuntamente
# obteniendo así lo que se conoce como DDNS. Consiste simplemente en permitir a DHCP
# "escribir" en los registros de DNS. Para ello primero creamos una carpeta
# Que llamaremos keys dentro de /etc/bind y otorgaremos el permiso especial de
# ejecución como si fuese un usuario del grupo bind y damos permisos al usuario
# root y grupo bind de lectura y ejecución y a otros 0.
# Seguidamente crearemos una clave que guardaremos en la carpeta anterior en la
# que daremos permisos de 540
# Hecho esto ahora en el archivo named.conf.local añadimos lo siguiente:
#      include "/etc/bind/keys/iescalquera.local.key";
#  y dentro de las configuraciones de cada zona directa e inversa del dominio:
#      allow-update {key ddns-key.iescalquera.local;};
# Con esto tenemos configurado nuestro DNS para usar la clave que creamos. Pero
# necesitamos también añadirla en el DHCP para ello: en el archivo /etc/dhcp/dhcpd.conf
# comentamos o borramos  la linea: ddns-update-style none;
# y añadimos:
#     ddns-update-style interim;
#     update-static-leases on;
#     ddns-domainname "iescalquera.local";
# Si os fijáis en la ultima linea lo comparamos de manera distinta. Esto es para
# que si nuestro servidor DNS ofrece servicio a varios dominios y nuestro DHCP
# contiene varios ámbitos para que funcione correctamente con claves distintas para
# para varias zonas.
# Ahora solo queda añadir al final del archivo
#         include \"/etc/bind/keys/keys/iescalquera.local.key\";
#         Zona iescalquera.local
#             zone iescalquera.local {
#             primary (IP DEL SERVIDOR DNS);
#             key ddns-key.iescalquera.local;
#         }
#         Zona $i
#             zone 5.16.172.in-addr.arpa {
#             primary (IP DEL SERVIDOR DNS);
#             key ddns-key.iescalquera.local;
#         }
# Con esto tendríamos configurado para que nuestro DNS permita las actualizaciones
# de nuestro servidor DHCP.
# Si disponemos de reservas de IP debemos añadir en cada reserva:
#    ddns-hostname "nombre que queremos que se registre en el DNS"
######################################
#            Variables               #
######################################
source ../000_variables.sh

test -d ${DirConfDNS}keys || (mkdir ${DirConfDNS}keys && chmod 2550 ${DirConfDNS}keys )

for i in $(cat $ConfZonas | grep -v "#" | cut -d "," -f1)
do
  ddns-confgen -a hmac-md5 -z $i -r /dev/urandom | grep -v "#" -m4 > ${DirConfDNS}keys/${i}.key
  chmod 540 ${DirConfDNS}keys/${i}.key
  if [ $(cat ${DirConfDNS}named.conf.local | grep "\include \"/etc/bind/keys/${i}.key\";" | wc -l) = 0 ]
    then
      sed -i "/^# Zona $i/a\include \"/etc/bind/keys/${i}.key\";" ${DirConfDNS}named.conf.local
      sed -i "/file \"db.$i\";/a\allow-update {key ddns-key.$i;};" ${DirConfDNS}named.conf.local
      sed -i "/file \"db.$(cat $ConfZonas| grep $i | cut -d, -f2)\";/a\allow-update {key ddns-key.$i;};" ${DirConfDNS}named.conf.local
  fi
  if [ $(cat /etc/dhcp/dhcpd.conf | grep "^ddns-update-style none;" | wc -l) = 1 ]
    then
      sed -i 's/^ddns-update-style none;/####&/' /etc/dhcp/dhcpd.conf
      sed -i "/^####ddns-update-style none;/a\ddns-update-style interim;" /etc/dhcp/dhcpd.conf
      sed -i "/^ddns-update-style interim/a\update-static-leases on;" /etc/dhcp/dhcpd.conf
  fi
  if [ $(cat /etc/dhcp/dhcpd.conf | grep "^ddns-domainname \"$i\";" | wc -l) = 0 ]
    then
      sed -i "/^update-static-leases on/a\ddns-domainname \"$i\";" /etc/dhcp/dhcpd.conf
  fi

  a=$(cat $ConfZonas| grep $i | cut -d, -f2)
  iprev=(`echo "$a" | cut -d. -f1` `echo "$a" | cut -d. -f2` `echo "$a" | cut -d. -f3` `echo "$a" | cut -d. -f4`)
  if [ $(cat /etc/dhcp/dhcpd.conf | grep "include \"${DirConfDNS}keys/${i}.key\";" | wc -l) != 1 ]
    then
      echo "include \"${DirConfDNS}keys/${i}.key\";
      # Zona $i
      zone $i {
        primary $ServerIp;
        key ddns-key.$i;
      }
      # Zona $i
      zone ${iprev[2]}.${iprev[1]}.${iprev[0]}.in-addr.arpa {
      primary $ServerIp;
      key ddns-key.$i;
      }
      " >> /etc/dhcp/dhcpd.conf
  fi
done

/etc/init.d/bind9 restart
/etc/init.d/isc-dhcp-server restart
