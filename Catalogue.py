import os
import requests
import certifi

# Les informations d'identification pour se connecter au site Web
username = 'kurotix'
password = 'toto78'

# L'URL du site Web
url = 'https://toto.fr'

# Établir une session pour conserver les cookies de connexion
session = requests.Session()

# Charger le bundle de certificats de confiance de certifi
cafile = certifi.where()

# Définir la variable d'environnement REQUESTS_CA_BUNDLE sur le chemin d'accès du bundle de certificats
os.environ['REQUESTS_CA_BUNDLE'] = cafile

# Authentification en envoyant la demande de connexion
session.post(url + '/login', data={'username': username, 'password': password})

# Accédez à la page de téléchargement
response = session.get(url + '/visuel')

# Vérifier si la page a été chargée avec succès
if response.status_code == 200:
    # Extraire le jeton CSRF du contenu HTML de la page
    csrf_token = response.content.split('csrf_token')[1].split('value="')[1].split('"')[0]

    # Construire la demande de téléchargement JSON en incluant le jeton CSRF
    download_request = {'csrf_token': csrf_token}

    # Envoyer la demande de téléchargement JSON en simulant le clic sur le bouton "Download Report"
    download_response = session.post(url + '/download', data=download_request)

    # Vérifier si le téléchargement a réussi
    if download_response.status_code == 200:
        print('Téléchargement réussi !')
    else:
        print('Le téléchargement a échoué.')
else:
    print('La page de téléchargement n\'a pas pu être chargée.')
