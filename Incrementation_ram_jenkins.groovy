from selenium import webdriver
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

# Configuration des options pour le navigateur
chrome_options = Options()
# Activer le mode headless si nécessaire (décommentez la ligne suivante)
# chrome_options.add_argument("--headless")

# Initialiser le service ChromeDriver avec webdriver-manager
service = Service(ChromeDriverManager().install())
driver = webdriver.Chrome(service=service, options=chrome_options)

try:
    # Accéder à la page de connexion
    driver.get('https://toto.echonet/cjoc/')

    # Attendre que les éléments de connexion soient chargés
    wait = WebDriverWait(driver, 10)

    # Exemple de connexion (remplacez par les sélecteurs et les données de connexion corrects)
    username_input = wait.until(EC.presence_of_element_located((By.NAME, 'username')))
    password_input = driver.find_element(By.NAME, 'password')

    # Saisir les informations de connexion
    username_input.send_keys('your-username')  # Remplacez par votre nom d'utilisateur
    password_input.send_keys('your-password')  # Remplacez par votre mot de passe
    password_input.send_keys(Keys.RETURN)  # Soumettre le formulaire

    # Attendre que la page d'accueil après connexion soit chargée
    wait.until(EC.url_to_be('https://toto.echonet/cjoc/'))

    # Accéder à la page spécifique
    driver.get('https://toto.echonet/cjoc/p-ilyes-78/configure')

    # Attendre que le contenu de la page soit chargé
    page_content = wait.until(EC.presence_of_element_located((By.TAG_NAME, 'body')))
    print(page_content.text)

finally:
    # Fermer le navigateur
    driver.quit()
