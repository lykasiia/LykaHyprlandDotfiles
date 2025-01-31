#!/bin/bash

# Fonction pour afficher des boîtes de dialogue avec whiptail
function info_box {
    whiptail --title "$1" --msgbox "$2" 10 50
}

function yesno_box {
    whiptail --title "$1" --yesno "$2" 10 50
}

# Définition des variables
CONFIG_DIR="$HOME/.config/hypr"
BACKUP_DIR="$HOME/hyprland_backup"
GIT_REPO="https://github.com/lykasiia/LykaHyprlandDotfiles.git"
ZSH_CUSTOM_CONFIG="$HOME/.zshrc"

# Mise à jour du système et installation des paquets nécessaires
if (yesno_box "Mise à jour et installation des dépendances" "Voulez-vous mettre à jour le système et installer les dépendances nécessaires ?"); then
    info_box "Mise à jour du système" "Mise à jour du système et installation des paquets nécessaires..."
    sudo pacman -Syu --noconfirm
    sudo pacman -S --noconfirm hyprland xdg-desktop-portal-hyprland waybar dunst rofi kitty nautilus firefox wl-clipboard swaylock swayidle zsh git fastfetch
else
    info_box "Abandon" "L'installation a été annulée."
    exit 1
fi

# Suppression de la configuration Hyprland de base
info_box "Suppression de la configuration de base" "Suppression de la configuration Hyprland de base..."
rm -rf "$HOME/.config/hypr" "$HOME/.config/waybar" "$HOME/.config/fastfetch"

# Récupération de la configuration depuis un dépôt Git
info_box "Clonage de la configuration" "Clonage de la configuration Hyprland depuis le dépôt Git..."
git clone "$GIT_REPO" "$HOME"

# Vérification que le clonage a réussi
if [ -d "$CONFIG_DIR" ]; then
    info_box "Succès" "Configuration Hyprland installée avec succès."
else
    info_box "Erreur" "Erreur : clonage du dépôt échoué."
    exit 1
fi

# Application de la configuration
info_box "Application de la configuration" "Application de la configuration Hyprland..."
cd "$HOME/LykaHyprlandDotfiles/src/"
mv .config/hypr "$HOME/.config/"
mv .config/waybar "$HOME/.config/"
mv .config/fastfetch "$HOME/.config/"

# Installation et configuration de Oh My Zsh
if (yesno_box "Installation de Oh My Zsh" "Voulez-vous installer Oh My Zsh ?"); then
    info_box "Installation d'Oh My Zsh" "Installation de Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    info_box "Oh My Zsh non installé" "L'installation d'Oh My Zsh a été annulée."
fi

# Appliquer la configuration .zshrc du dépôt si elle existe
if [ -f "$HOME/LykaHyprlandDotfiles/src/.zshrc" ]; then
    info_box "Application de la configuration Zsh" "Application de la configuration Zsh..."
    rm -rf "$ZSH_CUSTOM_CONFIG"
    mv "$HOME/LykaHyprlandDotfiles/.zshrc" "$ZSH_CUSTOM_CONFIG"
fi

# Changer le shell par défaut en Zsh
info_box "Changement du shell" "Changement du shell par défaut en Zsh..."
chsh -s $(which zsh)

# Nettoyage
info_box "Nettoyage" "Nettoyage des fichiers temporaires..."
rm -rf "$HOME/LykaHyprlandDotfiles"

# Message final
info_box "Installation terminée" "L'installation est terminée. Redémarre ta session pour appliquer les modifications."
exit 0