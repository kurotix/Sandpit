import requests
import json
import base64
import sys

# Récupération des arguments passés lors de l'exécution du script
if len(sys.argv) != 3:
    print("Usage: python script.py <username> <password>")
    sys.exit(1)

username = sys.argv[1]
password = sys.argv[2]

# Certificat SSL
cert_file = "cert.crt"

# URL de base de l'API
base_url = "https://toto/api/v1"

# Endpoint pour générer un token
token_endpoint = base_url + "/tokens/generate"

# Endpoint pour la requête GET après authentification avec le token
builds_endpoint = base_url + "/builds/16463"

# Encodage en base64 de l'authentification
auth = base64.b64encode(f"{username}:{password}".encode()).decode()

# En-têtes de la requête pour générer le token
headers = {
    "Content-Type": "application/x-www-form-urlencoded",
    "Authorization": f"Basic {auth}"
}

# Corps de la requête pour générer le token
data = {
    "grant_type": "client_credentials"
}

# Envoi de la requête pour générer le token
response = requests.post(token_endpoint, headers=headers, data=data, cert=cert_file)

# Vérification du code de réponse HTTP
if response.status_code != 200:
    print(f"Error: {response.status_code} {response.reason}")
    sys.exit(1)

# Récupération du token dans le corps de la réponse
token = response.json()["access_token"]
print("Token: ", token)

# En-têtes de la requête pour la requête GET après authentification avec le token
headers = {
    "Authorization": f"Bearer {token}"
}

# Envoi de la requête GET après authentification avec le token
response = requests.get(builds_endpoint, headers=headers, cert=cert_file)

# Vérification du code de réponse HTTP
if response.status_code != 200:
    print(f"Error: {response.status_code} {response.reason}")
    sys.exit(1)

# Affichage de la réponse en format JSON
print(json.dumps(response.json(), indent=4))
