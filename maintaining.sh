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
	echo -e "\e[${VERDE}O $DISTRO terminou as atualizações${RESET}"
	sleep 2
}

clean() {
	echo -e "${NEGRITO}A começar a limpeza${RESET}"
	sleep 2
	sudo dnf autoremove
	sudo dnf clean all
	echo -e "${VERDE}Sistema Limpo${RESET}"
	sleep 2
}

installApps() {
	echo -e "${NEGRITO}Quais aplicações quer instalar?${RESET}"
	read APPS

	if [[ $APPS == "" ]]
	then
	    echo -e "${VERMELHO}Sem apps para instalar${RESET}"
	else
	    sudo dnf install $APPS
	    echo -e "${VERDE}Aplicações Instaladas${RESET}"
	fi
	
	sleep 2
}

menu() {
	echo -e "${NEGRITO}Escolha uma opção:${RESET}"
	echo -e "${NEGRITO}1: Atualizar Sistema${RESET}"
	echo -e "${NEGRITO}2: Limpar Sistema${RESET}"
	echo -e "${NEGRITO}3: Instalar Aplicações${RESET}"
	
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

		*)
			echo -e "${VERMELHO}Não escolheu uma opção válida! A terminar.${RESET}"
			sleep 2
			exit
			;;
	esac
}

menu