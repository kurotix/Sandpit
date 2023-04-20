import requests
import json

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

# Vérifier le statut de la réponse
if response.status_code == 200:
    # Récupérer le token dans le corps de la réponse JSON
    token = response.json()["access_token"]
    
    # URL pour obtenir les informations de builds
    builds_url = "https://toto/api/v1/builds/16463"
    
    # Créer les en-têtes pour inclure le token d'authentification
    headers = {
        "Authorization": f"Bearer {token}"
    }
    
    # Envoyer la requête GET pour obtenir les informations de builds
    builds_response = requests.get(builds_url, headers=headers, verify="certif.crt")
    
    # Vérifier le statut de la réponse
    if builds_response.status_code == 200:
        # Afficher le contenu de la réponse JSON
        print(json.dumps(builds_response.json(), indent=2))
        print("test DIM ok")
    else:
        # Afficher un message d'erreur
        print("Erreur lors de la récupération des informations de builds")
else:
    # Afficher un message d'erreur
    print("Erreur lors de la génération du token")    
