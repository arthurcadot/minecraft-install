#!/bin/bash

# Vérifier si git est installé, sinon l'installer
if ! command -v git &> /dev/null
then
    echo "Git n'est pas installé. Installation de git..."
    sudo apt update
    sudo apt install -y git
fi

# Se rendre dans le dossier minecraft-install
cd ~/minecraft-install

# Vérifier si dpkg est installé, sinon l'installer
if ! command -v dpkg &> /dev/null
then
    echo "dpkg n'est pas installé. Installation de dpkg..."
    sudo apt update
    sudo apt install -y dpkg
fi

# Installer le fichier minecraft.deb
sudo dpkg -i ~/minecraft-install/minecraft.deb

# Vérifier si Java est installé
if ! command -v java &> /dev/null
then
    echo "Java n'est pas installé. Installation de la dernière version..."
    # Installer la dernière version de Java (OpenJDK)
    sudo apt update
    sudo apt install -y openjdk-17-jdk
fi

# Lancer fabric.jar
java -jar ~/minecraft-install/fabric.jar

# Vérifier si le dossier ~/.minecraft/mods/ existe
while [ ! -d "$HOME/.minecraft/mods" ]; do
    echo "Le dossier ~/.minecraft/mods/ n'existe pas. Réinstaler fabric puis enter pour continuer ? (O/n)"
    read -p "Appuyez sur O pour oui (O/n) : " confirm

    # Par défaut, continuer si l'utilisateur appuie simplement sur Entrée (O)
    if [[ ! "$confirm" =~ ^[Nn]$ ]]; then
        echo "Revérification si le dossier ~/.minecraft/mods/ existe !"
    else
        echo "Arrêt du script."
        exit 1
    fi
done

echo "Instalation de fabric réussi !"

# Déplacer tous les fichiers du dossier mods vers ~/.minecraft/mods/
mv ~/minecraft-install/mods/* ~/.minecraft/mods/
echo "Les mods ont été déplacés dans ~/.minecraft/mods/"

# Créer un lanceur dans le menu des applications
echo "[Desktop Entry]
Name=Minecraft Launcher
Comment=Lance Minecraft
Exec=$HOME/.minecraft/launcher/minecraft-launcher
Icon=$HOME/minecraft-install/icon.png
Terminal=false
Type=Application
Categories=Game;" > ~/.local/share/applications/minecraft-launcher.desktop

# Mettre à jour les permissions pour que le fichier soit exécutable
chmod +x ~/.local/share/applications/minecraft-launcher.desktop
echo "Le lanceur Minecraft a été ajouté au menu des applications avec l'icône."

# Afficher le fichier README.md avec défilement
clear
cat ~/minecraft-install/README.md

#FIN
