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

    # Vérifier si "windows_58" est présent dans "DisplayName"
    $displayName = $response.displayName
    if ($displayName -eq "windows_58") {
        Write-Output "Le nœud Jenkins a le label 'windows_58'."
    } else {
        Write-Output "Le nœud Jenkins n'a pas le label 'windows_58'."
    }

} catch {
    # En cas d'erreur lors de la requête
    Write-Output "Erreur lors de la requête vers l'API Jenkins : $_"
}
