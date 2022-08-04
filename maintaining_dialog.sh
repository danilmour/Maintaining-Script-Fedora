# Debug Mode
# set -x

DISTRO="Fedora"

update() {
	for (( i = 0; i < 100; i += 50 )); do
		echo $i
		sleep 1
	done | whiptail --title "Atualização do Sistema" --gauge "O $DISTRO vai procurar agora por atualizações" 10 70 0
	
	sudo dnf update

	for (( i = 0; i < 100; i += 50 )); do
		echo $i
		sleep 1
	done | whiptail --title "Atualização do Sistema" --gauge "O $DISTRO vai procurar agora por atualizações de pacotes Flatpak" 10 70 0

	sudo flatpak update

	for (( i = 0; i < 100; i += 50 )); do
		echo $i
		sleep 1
	done | whiptail --title "Atualização do Sistema" --gauge "O $DISTRO vai procurar agora por atualizações de pacotes Snap" 10 70 0

	sudo snap refresh

	whiptail --title "Atualização do Sistema" --msgbox "O $DISTRO terminou as atualizações" 10 70
}

clean() {
	for (( i = 0; i < 100; i += 95 )); do
		echo $i
		sleep 1
	done | whiptail --title "Limpeza do Sistema" --gauge "A começar a limpeza" 10 70 0

	sudo dnf autoremove
	sudo dnf clean all
	sudo flatpak uninstall --unused
	
	whiptail --title "Limpeza do Sistema" --msgbox "Sistema Limpo" 10 70
}

installApps() {
	PACKAGE_MANAGER=$(whiptail --title "Escolha de Gestor de Pacotes" --menu "Qual dos seguintes gestores pretende utilizar?" 10 70 0 \
		"DNF" "" \
		"Flatpak" "" \
		3>&1 1>&2 2>&3)


	APPS=$(whiptail --title "Aplicações a Instalar" --inputbox "Quais aplicações quer instalar?" 10 70 \
		3>&1 1>&2 2>&3)
	
	if [[ $APPS == "" ]]
	then
	    whiptail --title "Aplicações a Instalar" --msgbox "Sem apps para instalar" 10 70
	else
		whiptail --title "Instalação" --msgbox "A instalar ${APPS} com o ${PACKAGE_MANAGER}" 10 70

		case $PACKAGE_MANAGER in
			"DNF")
			    sudo dnf install $APPS
				;;

			"Flatpak")
				sudo flatpak install $APPS
				;;
		esac

	    whiptail --title "Aplicações a Instalar" --msgbox "Aplicações Instaladas" 10 70
	fi
}

info() {
	cat /etc/os-release
}

turnOff() {
	if (whiptail --title "Desligar o Sistema" --yesno "Tem a certeza que pretende Desligar o Sistema?" 10 70); then
		for (( i = 0; i < 100; i += 97 )); do
			echo $i
			sleep 2
		done | whiptail --title "Desligar o Sistema" --gauge "O Sistema vai Desligar" 10 70 0

		sudo poweroff
	fi
}

menu() {
	CHOICE=$(whiptail --title "Menu Principal" --menu "Escolha uma opção" 20 70 0 \
			"Atualizar o Sistema" "" \
			"Limpar o Sistema" "" \
			"Instalar Aplicações" "" \
			"Informações do Sistema" "" \
			"Desligar o Sistema" "" \
			3>&1 1>&2 2>&3)

	case $CHOICE in
		"Atualizar o Sistema")
			update
			;;

		"Limpar o Sistema")
			clean
			;;

		"Instalar Aplicações")
			installApps
			;;

		"Informações do Sistema")
			info
			;;

		"Desligar o Sistema")
			turnOff
			;;
	esac
}

if [[ $(whoami) != root ]]; then
	echo "O programa tem de ser executado com o utilizador root!"
	exit
fi

menu