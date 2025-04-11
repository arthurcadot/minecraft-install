#!/bin/bash

# Vérifier si git est installé, sinon l'installer
if ! command -v git &> /dev/null
then
    echo "Git n'est pas installé. Installation de git..."
    sudo apt update
    sudo apt install -y git
fi

# Se rendre dans le répertoire personnel
cd ~

# Cloner le dépôt Git
git clone git@github.com:arthurcadot/minecraft-install.git

# Se rendre dans le dossier minecraft-install
cd minecraft-install

# Vérifier si dpkg est installé, sinon l'installer
if ! command -v dpkg &> /dev/null
then
    echo "dpkg n'est pas installé. Installation de dpkg..."
    sudo apt update
    sudo apt install -y dpkg
fi

# Installer le fichier minecraft.deb
sudo dpkg -i minecraft.deb

# Vérifier si Java est installé
if ! command -v java &> /dev/null
then
    echo "Java n'est pas installé. Installation de la dernière version..."
    # Installer la dernière version de Java (OpenJDK)
    sudo apt update
    sudo apt install -y openjdk-17-jdk
fi

# Lancer fabric.jar
java -jar fabric.jar

# Afficher un message et demander confirmation avant de continuer
echo "Vérifie que le dossier .minecraft est sélectionné et quitte quand c'est fini, puis tape sur entrer pour continuer"
read -p "Appuyez sur O pour oui (O/n) : "

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
mv mods/* ~/.minecraft/mods/
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

# Demander à l'utilisateur s'il souhaite procéder à la suppression des éléments
while true; do
    read -p "Puis-je m'auto détruire ? (O/N) " reponse
    if [[ "$reponse" =~ ^(O|o|)$ ]]; then
        # Supprimer le dossier minecraft-install
        cd ~
        rm -rf minecraft-install
        echo "Le dossier minecraft-install a été supprimé."
        
        # Supprimer ce script
        rm -- "$0"
        echo "Le script a été supprimé."
        break
    elif [[ "$reponse" =~ ^(N|n)$ ]]; then
    else
        echo "Réponse invalide, veuillez répondre par O ou N."
    fi
done

#FIN
