# Définir les informations d'identification pour l'accès à l'API Jenkins
$jenkinsUsername = "votre_nom_utilisateur"
$jenkinsAPIToken = "votre_token_api"  # Ou votre mot de passe si vous utilisez un mot de passe au lieu d'un token

# Créer les informations d'identification
$jenkinsCredential = New-Object System.Management.Automation.PSCredential ($jenkinsUsername, (ConvertTo-SecureString -String $jenkinsAPIToken -AsPlainText -Force))

# Définir l'URL de l'API Jenkins pour obtenir l'état du nœud
$jenkinsNodeAPI = "https://toto-devops.group/p-1451-ilyes/api/json"

# Fonction pour vérifier l'état du nœud Jenkins
function CheckJenkinsNodeStatus {
    try {
        # Exécuter une requête HTTP GET vers l'API Jenkins pour obtenir l'état du nœud
        $response = Invoke-RestMethod -Uri $jenkinsNodeAPI -Method Get -Credential $jenkinsCredential

        # Récupérer le statut du nœud
        $assignedLabels = $response.AssignedLabels
        $offline = $response.offline

        # Vérifier si le nœud est en ligne et si le label est "windows_58"
        if ($offline -eq $false -and $assignedLabels.name -eq "windows_58") {
            return $true
        } else {
            return $false
        }
    } catch {
        # En cas d'erreur lors de la requête
        Write-Output "Erreur lors de la requête vers l'API Jenkins : $_"
        return $null
    }
}

# Boucle principale
while ($true) {
    $nodeStatus = CheckJenkinsNodeStatus
    if ($nodeStatus -ne $null) {
        if ($nodeStatus -eq $true) {
            Write-Output "Le nœud Jenkins est en ligne et a le label 'windows_58'. Tout est bon."
        } else {
            Write-Output "Le nœud Jenkins est hors ligne ou n'a pas le bon label. Redémarrage des services..."
            # Ici, vous pouvez appeler une fonction pour redémarrer le service sur la VM
            # Remarque : cette partie dépendra de la manière dont vous gérez le redémarrage du service sur votre VM
        }
    }
    
    # Attendre 5 minutes avant de vérifier à nouveau
    Start-Sleep -Seconds 300
}
