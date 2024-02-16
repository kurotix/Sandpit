# Définir l'URL de l'API Jenkins
$jenkinsURL = "https://toto.group/p-2724-ilyes/computer/api/json"

# Définir le nom d'utilisateur et le token d'API
$jenkinsUsername = "votre_nom_utilisateur"
$jenkinsAPIToken = "votre_token_api"

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
        Write-Output "Le nœud Jenkins avec le label 'windows_58' est en ligne: $($offlineStatus -eq $false)"
    } else {
        Write-Output "Le nœud Jenkins avec le label 'windows_58' n'a pas été trouvé."
    }

} catch {
    # En cas d'erreur lors de la requête
    Write-Output "Erreur lors de la requête vers l'API Jenkins : $_"
}
