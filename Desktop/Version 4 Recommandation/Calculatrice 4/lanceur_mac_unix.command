#!/bin/bash

# Vérifie si Python est installé
if ! command -v python3 &> /dev/null; then
    echo "Erreur : Python n'est pas installé ou non reconnu dans le PATH."
    exit 1
fi

# Définition du chemin du projet
PROJECT_PATH="/Users/invite/Desktop/Version 4 Recommandation/Calculatrice 4"

# Vérifie si app.py existe
if [ ! -f "$PROJECT_PATH/app.py" ]; then
    echo "Erreur : Le fichier app.py est introuvable dans $PROJECT_PATH."
    exit 1
fi

# Se place dans le dossier du projet
cd "$PROJECT_PATH" || { echo "Erreur : Impossible d'accéder au dossier du projet."; exit 1; }

# Vérifie si le dossier virtuel existe
if [ ! -d "venv" ]; then
    echo "Erreur : L'environnement virtuel n'est pas configuré."
    exit 1
fi

# Activer l'environnement virtuel
source venv/bin/activate

# Vérifie si Flask est installé, sinon l'installe
if ! pip show flask &> /dev/null; then
    echo "Installation de Flask..."
    pip install flask
else
    echo "Flask est déjà installé."
fi

# Définit l'application Flask
export FLASK_APP=app.py

# Exécute l'application Flask via Python3
python3 app.py &

# Attendre quelques secondes avant d'ouvrir la page HTML
sleep 5

# Ouvre la page dans le navigateur par défaut
osascript -e 'tell application "Terminal" to activate and do script "open http://127.0.0.1:5001"'

echo "Flask a été lancé avec succès. Accédez à http://127.0.0.1:5001"
