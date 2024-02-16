# Définir le chemin du répertoire contenant les dossiers Jenkins
$jenkinsDir = "E:/"

# Définir le nom d'utilisateur et le token d'API Jenkins
$jenkinsUsername = "votre_nom_utilisateur"
$jenkinsAPIToken = "votre_token_api"

# Créer l'en-tête d'authentification avec le nom d'utilisateur et le token d'API
$headers = @{
    Authorization = "Basic " + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("$($jenkinsUsername):$($jenkinsAPIToken)"))
}

# Obtenir la liste des dossiers commençant par "jenkins-" dans le répertoire spécifié
$jenkinsFolders = Get-ChildItem -Path $jenkinsDir -Directory | Where-Object { $_.Name -like "jenkins-*" -and $_.Name -match "p-\d{4}-\w+" }

foreach ($folder in $jenkinsFolders) {
    # Extraire le nom final du dossier (par exemple, "p-1713-ilyes")
    $finalName = ($folder.Name -split "jenkins-")[-1]

    try {
        # Définir l'URL de l'API Jenkins pour ce nœud
        $jenkinsURL = "https://toto.group/p-$finalName/computer/api/json"

        # Exécuter une requête HTTP GET vers l'API Jenkins pour obtenir l'état du nœud
        $response = Invoke-RestMethod -Uri $jenkinsURL -Headers $headers -Method Get

        # Vérifier si le nœud est en ligne (offline: false)
        $offlineStatus = $response.offline

        if (-not $offlineStatus) {
            Write-Output "Le nœud Jenkins '$finalName' est en ligne."
        } else {
            Write-Output "Le nœud Jenkins '$finalName' n'est pas en ligne. Redémarrage du service jenkins-slave-$finalName."

            # Redémarrer le service Jenkins si le nœud n'est pas en ligne
            $serviceToRestart = "jenkins-slave-p-$finalName"
            Restart-Service -Name $serviceToRestart
            Write-Output "Le service $serviceToRestart a été redémarré."
        }

    } catch {
        # En cas d'erreur lors de la requête
        Write-Output "Erreur lors de la requête vers l'API Jenkins pour le nœud '$finalName' : $_"
    }
}
