import requests
import json
from base64 import b64encode

# Définir les informations d'authentification
username = input("Entrez votre nom d'utilisateur : ")
password = input("Entrez votre mot de passe : ")

# URL pour générer un token
token_url = "https://toto/api/v1/tokens/generate"

# Créer le corps de la demande avec les informations d'authentification
auth_data = {
    "username": username,
    "password": password
}

# Envoyer la requête POST pour générer un token
response = requests.post(token_url, data=auth_data, verify="certif.crt")

# Afficher la réponse JSON
print(json.dumps(response.json(), indent=2))
