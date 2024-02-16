# Définir l'URL de l'API Jenkins
$jenkinsURL = "https://toto.group/p-2724-ilyes/api/json"

# Définir le nom d'utilisateur et le token d'API
$jenkinsUsername = "votre_nom_utilisateur"
$jenkinsAPIToken = "votre_token_api"

try {
    # Créer l'en-tête d'authentification avec le nom d'utilisateur et le token d'API
    $headers = @{
        Authorization = "Basic " + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("$($jenkinsUsername):$($jenkinsAPIToken)"))
    }

    # Exécuter une requête HTTP GET vers l'API Jenkins pour obtenir l'état du nœud
    $response = Invoke-RestMethod -Uri $jenkinsURL -Headers $headers -Method Get

    # Vérifier si le nœud est présent dans le bloc "assignedLabels" avec le nom "windows_58"
    $nodeFound = $false
    foreach ($label in $response.assignedLabels) {
        if ($label.name -eq "windows_58") {
            $nodeFound = $true
            break
        }
    }

    if ($nodeFound) {
        # Vérifier si le nœud est en ligne (offline: false)
        $offlineStatus = $response.offline
        if ($offlineStatus -eq $false) {
            Write-Output "Le nœud Jenkins est en ligne avec le label 'windows_58'."
        } else {
            Write-Output "Le nœud Jenkins est hors ligne avec le label 'windows_58'."
        }
    } else {
        Write-Output "Le nœud Jenkins avec le label 'windows_58' n'a pas été trouvé."
    }
} catch {
    # En cas d'erreur lors de la requête
    Write-Output "Erreur lors de la requête vers l'API Jenkins : $_"
}
