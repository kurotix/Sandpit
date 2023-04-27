import requests
from bs4 import BeautifulSoup

# Créer une session pour maintenir l'état de connexion
session = requests.Session()

# Se connecter et accéder à la page de téléchargement
login_url = "https://toto.fr/login"
download_url = "https://toto.fr/visuel"
username = "kurotix"
password = "toto78"

# Récupérer le token CSRF
login_response = session.get(login_url)
soup = BeautifulSoup(login_response.content, "html.parser")
csrf_token = soup.find("input", {"name": "csrf_token"})["value"]

# Soumettre le formulaire de connexion
payload = {
    "username": username,
    "password": password,
    "csrf_token": csrf_token
}

session.post(login_url, data=payload)

# Télécharger le fichier JSON
download_response = session.get(download_url)

# Vérifier si le téléchargement est réussi
if download_response.status_code == 200:
    # Enregistrer le fichier JSON
    with open("report.json", "wb") as f:
        f.write(download_response.content)
    print("ok")
else:
    print("non ok")
