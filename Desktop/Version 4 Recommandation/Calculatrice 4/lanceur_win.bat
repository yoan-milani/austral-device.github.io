@echo off
:: Définir le chemin du projet
set "PROJECT_PATH=C:\Users\yoanm\Downloads\Python\Master Energie M2\M2 S1 Stage Austral Groupe Energie\Calculatrice 3"
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

:: Lancer l'application Flask
echo Démarrage de l'application Flask...
start cmd /k "cd /d %PROJECT_PATH% && call venv\Scripts\activate.bat && python app.py"

:: Attendre avant d'ouvrir le navigateur
timeout /t 2 >nul

:: Ouvrir le serveur Flask dans le navigateur
start "" "http://127.0.0.1:5000"

pause

