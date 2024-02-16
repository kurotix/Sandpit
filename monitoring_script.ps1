# Définir l'URL de l'API Jenkins
$jenkinsURL = "https://toto.group/p-2724-ilyes/computer/api/json"

# Définir le nom d'utilisateur et le token d'API
$jenkinsUsername = "votre_nom_utilisateur"
$jenkinsAPIToken = "votre_token_api"

# Définir le nom du service Jenkins à redémarrer
$serviceToRestart = "jenkins-slave-p-2725-check"

try {
    # Créer l'en-tête d'authentification avec le nom d'utilisateur et le token d'API
    $headers = @{
        Authorization = "Basic " + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("$($jenkinsUsername):$($jenkinsAPIToken)"))
    }

    # Exécuter une requête HTTP GET vers l'API Jenkins pour obtenir la liste des ordinateurs
    $response = Invoke-RestMethod -Uri $jenkinsURL -Headers $headers -Method Get

    # Parcourir les ordinateurs pour trouver celui avec "windows_58" comme DisplayName
    $windowsNode = $response.computer | Where-Object { $_.displayName -eq "windows_58" }

    if ($windowsNode) {
        # Vérifier si le nœud est en ligne (offline: false)
        $offlineStatus = $windowsNode.offline

        if (-not $offlineStatus) {
            Write-Output "Le nœud Jenkins avec le label 'windows_58' est en ligne."
        } else {
            Write-Output "Le nœud Jenkins avec le label 'windows_58' n'est pas en ligne. Redémarrage du service $serviceToRestart."

            # Redémarrer le service Jenkins si le nœud n'est pas en ligne
            Restart-Service -Name $serviceToRestart
            Write-Output "Le service $serviceToRestart a été redémarré."
        }
    } else {
        Write-Output "Le nœud Jenkins avec le label 'windows_58' n'a pas été trouvé."
    }

} catch {
    # En cas d'erreur lors de la requête
    Write-Output "Erreur lors de la requête vers l'API Jenkins : $_"
}
