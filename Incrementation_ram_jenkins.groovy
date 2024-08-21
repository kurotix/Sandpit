import requests
from bs4 import BeautifulSoup

# URL de connexion
login_url = 'https://toto.echonet/cjoc/login'
target_url = 'https://toto.echonet/cjoc/p-ilyes-78/configure'

# Chemin vers le certificat CA (remplacez par le chemin réel)
cert_path = '/path/to/certificate.pem'

# Créer une session
session = requests.Session()

# Les données de connexion
login_data = {
    'username': 'your-username',
    'password': 'your-password',
}

# Effectuer la connexion en spécifiant le chemin du certificat CA
response = session.post(login_url, data=login_data, verify=cert_path)

# Vérifier si la connexion a réussi
if response.ok:
    print("Connexion réussie")

    # Accéder à la page protégée
    response = session.get(target_url, verify=cert_path)

    # Vérifier si la demande a réussi
    if response.ok:
        # Afficher le contenu de la page
        soup = BeautifulSoup(response.text, 'html.parser')
        print(soup.prettify())
    else:
        print(f"Erreur lors de l'accès à la page protégée : {response.status_code}")
else:
    print(f"Erreur de connexion : {response.status_code}")
