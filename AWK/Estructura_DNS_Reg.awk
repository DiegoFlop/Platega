# Script creado por Fernández López, Diego
# En este script lo que realizamos el la reconfiguración de la estructura necesaria
# para poder trabajar con los archivos DNS. Para ello nos servimos de AWK para
# restructurarlo y escojemos el campo 1 de nuestro CSV como el campo que definirá
# que tipo de estrutura necesita dependiendo del registro.
# Hecho eso mediante el condicional IF lo printamos todo en un archivo txt que
# almacenaremos en la carpeta temporal. El cual se llamara como la/s zona/s que
# tengamos en nuestro csv de zonas. Para ello nos valdremos de la variable externa
# "dominio" para poder generar tantas estructuras como zonas tengamos.
BEGIN {FS= ","}
   {if ($1 ~ "^A")
	printf ("%-20s%-10s\t%-15s ; %s\n", $2, $1, $4, $6) > "/tmp/db."dominio".txt"
   }
   {split ($4, ip, ".")
	if ($1 ~ "^PTR")
	    printf ("%-20s%-10s\t%-15s ; %s\n", ip[4], $1, $2, $6) >> "/tmp/db."dominio".txt"
   }
   {if ($1 ~ "^CNAME")
	printf ("%-20s%-10s\t%-15s ; %s\n", $2, $1, $3, $6) >> "/tmp/db."dominio".txt"
   }
   {if ($1 ~ "^MX")
	printf ("%-20s%-6s%s\t%-15s ; %s\n", $2, $1, $5, $3, $6) >> "/tmp/db."dominio".txt"
   }
