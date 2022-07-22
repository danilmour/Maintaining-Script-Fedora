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

menu() {
	CHOICE=$(whiptail --title "Menu Principal" --menu "Escolha uma opção" 20 35 0 \
			"Atualizar o Sistema" "" \
			"Limpar o Sistema" "" \
			"Instalar Aplicações" "" \
			"Informações do Sistema" "" \
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
	esac
}

menu