# Définir le chemin du répertoire contenant les dossiers Jenkins
$jenkinsDir = "E:/"

# Définir le nom d'utilisateur et le token d'API Jenkins
$jenkinsUsername = "votre_nom_utilisateur"
$jenkinsAPIToken = "votre_token_api"

# Créer l'en-tête d'authentification avec le nom d'utilisateur et le token d'API
$headers = @{
    Authorization = "Basic " + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("$($jenkinsUsername):$($jenkinsAPIToken)"))
}

# Obtenir la liste des dossiers commençant par "Jenkins-" dans le répertoire spécifié
$jenkinsFolders = Get-ChildItem -Path $jenkinsDir -Directory | Where-Object { $_.Name -like "Jenkins-p-*" }

foreach ($folder in $jenkinsFolders) {
    # Extraire le nom final du dossier (par exemple, "p-1210-ilyes")
    $finalName = ($folder.Name -split "Jenkins-p-")[-1]

    try {
        # Définir l'URL de l'API Jenkins pour ce nœud
        $jenkinsURL = "https://toto.group/p-$finalName/computer/api/json"

        # Exécuter une requête HTTP GET vers l'API Jenkins pour obtenir la liste des ordinateurs
        $response = Invoke-RestMethod -Uri $jenkinsURL -Headers $headers -Method Get

        # Vérifier si le nœud avec le label "windows_58" est hors ligne (offline: true)
        $offlineStatus = $response.computer | Where-Object { $_.displayName -eq "windows_58" } | Select-Object -ExpandProperty offline

        if ($offlineStatus) {
            Write-Output "Le nœud Jenkins '$finalName' avec le label 'windows_58' est hors ligne. Redémarrage du service jenkins-slave-$finalName."

            # Redémarrer le service Jenkins si le nœud avec le label "windows_58" est hors ligne
            $serviceToRestart = "jenkins-slave-p-$finalName"
            Restart-Service -Name $serviceToRestart
            Write-Output "Le service $serviceToRestart a été redémarré."
        } else {
            Write-Output "Le nœud Jenkins '$finalName' avec le label 'windows_58' est en ligne."
        }

    } catch {
        # En cas d'erreur lors de la requête
        Write-Output "Erreur lors de la requête vers l'API Jenkins pour le nœud '$finalName' avec le label 'windows_58' : $_"
    }
}
