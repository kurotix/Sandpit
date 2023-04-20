import requests

# URL pour générer un token utilisateur
auth_url = "https://toto/api/v1/tokens/generate"

# Définir les informations d'authentification
auth = ("coco", "fifi")

# Effectuer la demande POST pour générer un token
response = requests.post(auth_url, auth=auth)

# Vérifier que la demande a été réussie
if response.status_code == 200:
    # Extraire le token à partir de la réponse JSON
    token = response.json()["token"]

    # URL pour effectuer une demande GET en utilisant le token
    url = "https://toto/api/v1/builds/2"

    # Ajouter l'en-tête d'authentification pour la demande GET
    headers = {"Authorization": f"Bearer {token}"}

    # Effectuer la demande GET
    response = requests.get(url, headers=headers)

    # Vérifier que la demande a été réussie
    if response.status_code == 200:
        # Afficher la réponse JSON
        print(response.json())
    else:
        print(f"La demande GET a échoué avec le code d'état {response.status_code}")
else:
    print(f"La demande POST pour générer un token a échoué avec le code d'état {response.status_code}")
