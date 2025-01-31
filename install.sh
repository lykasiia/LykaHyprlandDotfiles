#!/bin/bash

# Définition des variables
CONFIG_DIR="$HOME/.config/hypr"
BACKUP_DIR="$HOME/hyprland_backup"
GIT_REPO="https://github.com/lykasiia/LykaHyprlandDotfiles.git"
ZSH_CUSTOM_CONFIG="$HOME/.zshrc"

# Mise à jour du système et installation des paquets nécessaires
echo "Mise à jour du système et installation des dépendances..."
sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm hyprland xdg-desktop-portal-hyprland waybar dunst rofi kitty nautilus firefox wl-clipboard swaylock swayidle zsh git fastfetch

# Suppression de la configuration Hyprland de base
echo "Suppression de la configuration Hyprland de base..."
rm -rf "$HOME/.config/hypr" "$HOME/.config/waybar"

# Récupération de la configuration depuis un dépôt Git
echo "Clonage de la configuration Hyprland..."
git clone "$GIT_REPO" "$HOME"

# Vérification que le clonage a réussi
if [ -d "$CONFIG_DIR" ]; then
    echo "Configuration Hyprland installée avec succès."
else
    echo "Erreur : clonage du dépôt échoué."
    exit 1
fi

# Application de la configuration
echo "Application de la configuration Hyprland..."
cd "$HOME/LykaHyprlandDotfiles/src/"
mv .config/hypr "$HOME/.config/"
mv .config/waybar "$HOME/.config/"

# Installation et configuration de Oh My Zsh
echo "Installation de Oh My Zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Appliquer la configuration .zshrc du dépôt si elle existe
if [ -f "$HOME/LykaHyprlandDotfiles/src/.zshrc" ]; then
    echo "Application de la configuration Zsh..."
    rm -rf "$ZSH_CUSTOM_CONFIG"
    mv "$HOME/LykaHyprlandDotfiles/.zshrc" "$ZSH_CUSTOM_CONFIG"
fi

# Changer le shell par défaut en Zsh
echo "Changement du shell par défaut en Zsh..."
chsh -s $(which zsh)

# Nettoyage
echo "Nettoyage..."
rm -rf "$HOME/LykaHyprlandDotfiles"

echo "Installation terminée. Redémarre ta session pour appliquer les modifications."
exit 0