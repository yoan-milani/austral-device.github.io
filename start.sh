#!/bin/bash
source myenv/bin/activate  # Remplacez 'myenv' par le nom de votre environnement virtuel
pip install -r requirements.txt  # Installe les dépendances listées dans requirements.txt
python3 app.py  # Lance l'application Flask