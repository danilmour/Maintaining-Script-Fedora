#!/bin/bash

#-------------+--------------------------------------------#
# Script Name | maintaining_dialog.sh                      #
#-------------+--------------------------------------------#
# Purpose     | This script runs a set of commands related #
#             | to package managing and system information #
#-------------+--------------------------------------------#

# Debug Mode
set -x

DISTRO="Fedora"

#----------+----------------------------------------#
# Function | UPDATE                                 #
#----------+----------------------------------------#
# Purpose  | Update existing packages on the system #
#----------+----------------------------------------#
function UPDATE() {
    for ((i = 0; i < 100; i += 50)); do
        echo "${i}"
        sleep 1
    done | dialog --title "Atualização do Sistema" --gauge "O $DISTRO vai procurar agora por atualizações" 0 0 0

    sudo dnf update

    if [ "$(command -v flatpak)" ]; then
        for ((i = 0; i < 100; i += 50)); do
            echo "${i}"
            sleep 1
        done | dialog --title "Atualização do Sistema" --gauge "O $DISTRO vai procurar agora por atualizações de pacotes Flatpak" 0 0 0

        sudo flatpak update
    fi

    if [ "$(command -v snap)" ]; then
        for ((i = 0; i < 100; i += 50)); do
            echo "${i}"
            sleep 1
        done | dialog --title "Atualização do Sistema" --gauge "O $DISTRO vai procurar agora por atualizações de pacotes Snap" 0 0 0

        sudo snap refresh
    fi

    dialog --title "Atualização do Sistema" --msgbox "O $DISTRO terminou as atualizações" 0 0
}

#----------+-------------------------#
# Function | CLEAN                   #
#----------+-------------------------#
# Purpose  | Clean obsolete packages #
#----------+-------------------------#
function CLEAN() {
    for ((i = 0; i < 100; i += 95)); do
        echo "${i}"
        sleep 1
    done | dialog --title "Limpeza do Sistema" --gauge "A começar a limpeza" 0 0 0

    sudo dnf autoremove
    sudo dnf clean all

    if [ "$(command -v flatpak)" ]; then
        sudo flatpak uninstall --unused
    fi

    dialog --title "Limpeza do Sistema" --msgbox "Sistema Limpo" 0 0
}

#----------+---------------------------------------------------#
# Function | INSTALLAPPS                                       #
#----------+---------------------------------------------------#
# Purpose  | Install a set of applications that the user wants #
#----------+---------------------------------------------------#
function INSTALLAPPS() {
    PACKAGE_MANAGER=$(dialog --title "Escolha de Gestor de Pacotes" --menu "Qual dos seguintes gestores pretende utilizar?" 0 0 0 \
        "DNF" "" \
        "Flatpak" "" \
        "Snap" "" \
        --stdout)

    APPS=$(dialog --title "Aplicações a Instalar" --inputbox "Quais aplicações quer instalar?" 0 0 --stdout)

    if [[ -z "${APPS}" ]]; then
        dialog --title "Aplicações a Instalar" --msgbox "Sem apps para instalar" 0 0
    else
        dialog --title "Instalação" --msgbox "A instalar ${APPS} com o ${PACKAGE_MANAGER}" 0 0

        case "${PACKAGE_MANAGER}" in
        "DNF")
            sudo dnf install "$APPS"
            ;;

        "Flatpak")
            if [ "$(command -v flatpak)" ]; then
                sudo flatpak install "$APPS"
            else
                dialog --title "Erro" --msgbox "O ${PACKAGE_MANAGER} não está instalado no sistema!" 0 0
            fi
            ;;

        "Snap")
            if [ "$(command -v flatpak)" ]; then
                sudo snap install "$APPS"
            else
                dialog --title "Erro" --msgbox "O ${PACKAGE_MANAGER} não está instalado no sistema!" 0 0
            fi
            ;;
        esac

        dialog --title "Aplicações a Instalar" --msgbox "Aplicações Instaladas" 0 0
    fi
}

#----------+-------------------------#
# Function | INFO                    #
#----------+-------------------------#
# Purpose  | Show system information #
#----------+-------------------------#
function INFO() {
    dialog --msgbox "$(/etc/os-release)"
}

#----------+-------------------#
# Function | TURNOFF           #
#----------+-------------------#
# Purpose  | Turn computer off #
#----------+-------------------#
function TURNOFF() {
    if (dialog --title "Desligar o Sistema" --yesno "Tem a certeza que pretende Desligar o Sistema?" 10 70); then
        for ((i = 0; i < 100; i += 97)); do
            echo "${i}"
            sleep 2
        done | dialog --title "Desligar o Sistema" --gauge "O Sistema vai Desligar" 10 70 0

        sudo poweroff
    fi
}

#----------+-----------------------#
# Function | MENU                  #
#----------+-----------------------#
# Purpose  | Main menu for program #
#----------+-----------------------#
function MENU() {
    CHOICE=$(dialog --title "Menu Principal" --menu "Escolha uma opção:" 0 0 0 \
        "Atualizar o Sistema" "" \
        "Limpar o Sistema" "" \
        "Instalar Aplicações" "" \
        "Informações do Sistema" "" \
        "Desligar o Sistema" "" \
        --stdout)

    case "${CHOICE}" in
    "Atualizar o Sistema")
        UPDATE
        ;;

    "Limpar o Sistema")
        CLEAN
        ;;

    "Instalar Aplicações")
        INSTALLAPPS
        ;;

    "Informações do Sistema")
        INFO
        ;;

    "Desligar o Sistema")
        TURNOFF
        ;;
    esac
}

#--------------#
# MAIN PROCESS #
#--------------#
if [[ $(whoami) == "root" ]]; then
    MENU
else
    echo 'The script must be executed as root!'
    exit
fi
