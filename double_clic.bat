@echo off
:: Définir le chemin du projet (dossier contenant app.py)
set "PROJECT_PATH=C:\Users\yoanm\Downloads\Version 4 Recommandation\Calculatrice 4"
cd /d "%PROJECT_PATH%"

:: Vérifier si Python est installé
where python >nul 2>&1 || (
    echo Erreur : Python n'est pas installé ou non reconnu dans le PATH.
    pause
    exit /b 1
)

:: Créer un environnement virtuel s'il n'existe pas
if not exist "%PROJECT_PATH%\venv" (
    echo Création de l'environnement virtuel...
    python -m venv venv
)

:: Activer l'environnement virtuel
call "%PROJECT_PATH%\venv\Scripts\activate.bat"

:: Vérifier si Flask est installé, sinon l'installer
python -c "import flask" 2>nul || (
    echo Flask n'est pas installé. Installation en cours...
    pip install Flask
)

:: Démarrer Flask sur le port 5002
echo Démarrage de l'application Flask...
start cmd /k "cd /d %PROJECT_PATH% && call venv\Scripts\activate.bat && python app.py"

:: Attendre avant d'ouvrir le navigateur
timeout /t 2 >nul

:: Ouvrir le serveur Flask dans le navigateur
start "" "http://127.0.0.1:5002"

pause
