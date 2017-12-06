#!/bin/bash
function compr_DNS_reg {
  # Comprobamos si existe el archivo de registros de DNS
    if test -f ${DirDbDNS}db.${i}
      then
        echo "$FechaLog El archivo: ${DirDbDNS}db.${i}  ya existe" >> ../Salidas/DNS.sal
      else
        cp /etc/bind/db.empty ${DirDbDNS}db.${i}
    fi
}
