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

    # Afficher tous les labels présents dans la réponse
    Write-Output "Labels présents dans la réponse :"
    foreach ($label in $response.assignedLabels) {
        Write-Output "- $($label.name)"
    }

} catch {
    # En cas d'erreur lors de la requête
    Write-Output "Erreur lors de la requête vers l'API Jenkins : $_"
}
