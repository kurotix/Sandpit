# Définir les informations d'identification pour accéder à Jenkins
$jenkinsUsername = "votre_nom_utilisateur"
$jenkinsPassword = ConvertTo-SecureString "votre_mot_de_passe" -AsPlainText -Force
$jenkinsCredential = New-Object System.Management.Automation.PSCredential ($jenkinsUsername, $jenkinsPassword)

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

# Fonction pour redémarrer le service sur la VM
function RestartVMService {
    # Ajoutez ici le code pour redémarrer le service sur votre VM
    # Par exemple :
    Restart-Service -Name "nom_du_service" -Force
}

# Boucle principale
while ($true) {
    $nodeStatus = CheckJenkinsNodeStatus
    if ($nodeStatus -ne $null) {
        if ($nodeStatus -eq $true) {
            Write-Output "Le nœud Jenkins est en ligne et a le label 'windows_58'. Tout est bon."
        } else {
            Write-Output "Le nœud Jenkins est hors ligne ou n'a pas le bon label. Redémarrage des services..."
            RestartVMService
        }
    }
    
    # Attendre 5 minutes avant de vérifier à nouveau
    Start-Sleep -Seconds 300
}
