import requests
from bs4 import BeautifulSoup

# URL de connexion
login_url = 'https://toto.echonet/cjoc/login'  # Remplacez par l'URL de connexion réelle
target_url = 'https://toto.echonet/cjoc/p-ilyes-78/configure'  # URL de la page à accéder après connexion

# Créer une session
session = requests.Session()

# Les données de connexion (modifiez en fonction du formulaire de connexion)
login_data = {
    'username': 'your-username',  # Remplacez par votre nom d'utilisateur
    'password': 'your-password',  # Remplacez par votre mot de passe
}

# Effectuer la connexion
response = session.post(login_url, data=login_data)

# Vérifier si la connexion a réussi
if response.ok:
    print("Connexion réussie")

    # Accéder à la page protégée
    response = session.get(target_url)

    # Vérifier si la demande a réussi
    if response.ok:
        # Afficher le contenu de la page
        soup = BeautifulSoup(response.text, 'html.parser')
        print(soup.prettify())
    else:
        print(f"Erreur lors de l'accès à la page protégée : {response.status_code}")
else:
    print(f"Erreur de connexion : {response.status_code}")
