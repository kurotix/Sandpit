import requests
import sys

# URL pour générer le token
token_url = "https://toto/api/v1/tokens/generate"

# URL pour récupérer des informations sur un build
build_url = "https://toto/api/v1/builds/2"

# Informations d'authentification
if len(sys.argv) == 3:
    auth = (sys.argv[1], sys.argv[2])
else:
    print("Veuillez fournir un nom d'utilisateur et un mot de passe.")
    sys.exit()

# Chemin vers le fichier de certificat SSL
cert_file = "mycert.pem"

# Requête POST pour générer un token
response = requests.post(token_url, auth=auth, verify=cert_file)

# Vérifier si la requête a réussi
if response.status_code == 200:
    # Extraire le token de la réponse JSON
    token = response.json()["access_token"]
    print("Token généré :", token)
    
    # Requête GET pour récupérer des informations sur un build en utilisant le token
    headers = {"Authorization": "Bearer " + token}
    response = requests.get(build_url, headers=headers, verify=cert_file)

    # Vérifier si la requête a réussi
    if response.status_code == 200:
        # Extraire les informations de build de la réponse JSON
        build_info = response.json()
        print("Informations sur le build :", build_info)
    else:
        print("La requête GET pour récupérer des informations sur le build a échoué avec le code d'état", response.status_code)
else:
    print("La requête POST pour générer un token a échoué avec le code d'état", response.status_code)
