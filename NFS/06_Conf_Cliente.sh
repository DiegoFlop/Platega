# Instalacion de servicio NFS en clientes
apt install nfs-common -y

# Creamos las carpetas para su posterior montaje
test -d $DirUsers || mkdir $DirUsers
test -d $MountComun || mkdir $MountComun

# montamos los directorios
if [[ $(cat /etc/fstab | grep "$DirUsers" | wc -l) == 0 ]]
then
	echo "${NombreServer}:$DirUsers	$MountUser	nfs	defaults,_netdev	0	0" >> /etc/fstab
fi

if [[ $(cat /etc/fstab | grep "$dircomun" | wc -l) == 0 ]]
then
	echo "${NombreServer}:$DirComun	$MountComun	nfs	defaults,_netdev	0	0" >> /etc/fstab
fi
mount -a

# Activamos el inicio grafico desde dominio
if [[ $(cat /usr/share/lightdm/lightdm.conf.d/50-ubuntu.conf | grep "greeter-show-manual-login=true" | wc -l) == 0 ]]
then
	echo "greeter-show-manual-login=true" >> /usr/share/lightdm/lightdm.conf.d/50-ubuntu.conf
fi
# Impedimos que se muestren los usuarios que se conectaron anteriormente
if [[ $(cat /usr/share/lightdm/lightdm.conf.d/50-ubuntu.conf | grep "greeter-hide-users=true" | wc -l) == 0 ]]
then
	echo "greeter-hide-users=true" >> /usr/share/lightdm/lightdm.conf.d/50-ubuntu.conf
fi
# Copiamos el script para montar accesos directos a los profesores
cp ../Configuracion/marcadores.sh /opt/

# Hacemos que se ejecute al iniciar sesion un profesor
sed -i '/# and Bourne compatible shells (bash(1), ksh(1), ash(1), \.\.\.)\./a sh \/opt\/marcadores.sh' /etc/profile
chmod 755 /opt/marcadores.sh

service lightdm restart
