import requests

# Ignorer les erreurs de certificat SSL auto-signé
requests.packages.urllib3.disable_warnings()

# Créer une session pour maintenir l'état de connexion
session = requests.Session()

# Ignorer les erreurs de certificat SSL pour toutes les requêtes
session.verify = False

# Se connecter et accéder à la page de téléchargement
login_url = "https://toto.fr/login"
download_url = "https://toto.fr/visuel"
username = "kurotix"
password = "toto78"

payload = {
    "username": username,
    "password": password,
}

session.post(login_url, data=payload)
download_response = session.get(download_url)

# Télécharger le contenu du fichier JSON
json_content = download_response.content
