#!/bin/bash

# Vérifie si Python est installé
if ! command -v python3 &> /dev/null; then
    echo "Erreur : Python n'est pas installé ou non reconnu dans le PATH."
    exit 1
fi

# Définition du chemin du projet
PROJECT_PATH="/Users/invite/Desktop/Version 2 M2 S1 Stage Austral Groupe Energie/Calculatrice 3"

# Vérifie si app.py existe
if [ ! -f "$PROJECT_PATH/app.py" ]; then
    echo "Erreur : Le fichier app.py est introuvable dans $PROJECT_PATH."
    exit 1
fi

# Se place dans le dossier du projet
cd "$PROJECT_PATH" || exit 1

# Définit l'application Flask
export FLASK_APP=app.py

# Exécute Flask en arrière-plan
python3 -m flask run &

# Attendre quelques secondes avant d'ouvrir la page
sleep 2

# Ouvre la page dans le navigateur par défaut
open http://127.0.0.1:5000

echo "Flask a été lancé avec succès. Accédez à http://127.0.0.1:5000"
