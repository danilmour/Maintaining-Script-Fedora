# Debug Mode
# set -x

DISTRO="Fedora"
RESET="\e[0m"
NEGRITO="\e[0;1m"
VERMELHO="\e[31;1m"
VERDE="\e[32;1m"

update() {
	echo -e "${NEGRITO}O $DISTRO vai procurar agora por atualizações${RESET}"
	sleep 2
	sudo dnf update
	sudo flatpak update
	echo -e "\e[${VERDE}O $DISTRO terminou as atualizações${RESET}"
	sleep 2
}

clean() {
	echo -e "${NEGRITO}A começar a limpeza${RESET}"
	sleep 2
	sudo dnf autoremove
	sudo dnf clean all
	sudo flatpak uninstall --unused
	echo -e "${VERDE}Sistema Limpo${RESET}"
	sleep 2
}

installApps() {
	echo -e "${NEGRITO}Qual dos seguintes gestores pretende utilizar?${RESET}"
	echo -e "${NEGRITO}1: DNF${RESET}"
	echo -e "${NEGRITO}2: Flatpak${RESET}"
	read PACKAGE_MANAGER

	if [ $PACKAGE_MANAGER == 1 ]
	then
		PM_NAME="DNF"
	fi

	if [ $PACKAGE_MANAGER == 2 ]
	then
		PM_NAME="Flatpak"
	fi

	echo -e "${NEGRITO}Quais aplicações quer instalar?${RESET}"
	read APPS

	if [[ $APPS == "" ]]
	then
	    echo -e "${VERMELHO}Sem apps para instalar${RESET}"
	else
		echo -e "${NEGRITO}A instalar aplicações com o ${PM_NAME}${RESET}"

		case $PACKAGE_MANAGER in
			1)
			    sudo dnf install $APPS
				;;

			2)
				sudo flatpak install $APPS
				;;

			*)
				echo -e "${VERMELHO}Opção Inválida! A terminar.${RESET}"
				sleep 2
				exit
				;;
		esac

	    echo -e "${VERDE}Aplicações Instaladas${RESET}"
	fi
	
	sleep 2
}

info() {
	cat /etc/os-release
	sleep 2
}

menu() {
	echo -e "${NEGRITO}Escolha uma opção:${RESET}"
	echo -e "${NEGRITO}1: Atualizar Sistema${RESET}"
	echo -e "${NEGRITO}2: Limpar Sistema${RESET}"
	echo -e "${NEGRITO}3: Instalar Aplicações${RESET}"
	echo -e "${NEGRITO}4: Informações do Sistema${RESET}"
	
	read ESCOLHA

	case $ESCOLHA in
		1)
			update
			;;
		
		2)
			clean
			;;

		3)
			installApps
			;;

		4)
			info
			;;

		*)
			echo -e "${VERMELHO}Não escolheu uma opção válida! A terminar.${RESET}"
			sleep 2
			exit
			;;
	esac
}

menu