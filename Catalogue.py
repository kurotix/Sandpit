import requests
from bs4 import BeautifulSoup
from selenium import webdriver

# Paramètres de connexion
username = "kurotix"
password = "toto78"

# Créer une session pour maintenir l'état de connexion
session = requests.Session()

# Se connecter
login_url = "https://toto.fr/login"
login_page = session.get(login_url)
soup = BeautifulSoup(login_page.content, "html.parser")
csrf_token = soup.find("input", {"name": "csrf_token"})["value"]
payload = {
    "username": username,
    "password": password,
    "csrf_token": csrf_token,
}
session.post(login_url, data=payload)

# Charger la page de téléchargement
download_url = "https://toto.fr/visuel"
driver = webdriver.Chrome()  # utilisez le navigateur de votre choix
driver.get(download_url)

# Trouver le bouton de téléchargement et le déclencher
download_button = driver.find_element_by_css_selector(".download-report")
download_button.click()

# Fermer le navigateur
driver.quit()
