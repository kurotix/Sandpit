# Définir les informations d'identification pour accéder à Jenkins avec un token d'API
$jenkinsUsername = "votre_nom_utilisateur"
$jenkinsAPIToken = "votre_token_api"
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
            $restartResult = RestartVMService
            if ($restartResult -eq $true) {
                Write-Output "Le redémarrage du service a été effectué avec succès. Vérification du statut du nœud Jenkins..."
                # Attendre jusqu'à 20 secondes maximum avant de vérifier à nouveau
                $timeout = 20
                $startTime = Get-Date
                $nodeStatusAfterRestart = $false
                while ((Get-Date) - $startTime -lt ([TimeSpan]::FromSeconds($timeout))) {
                    Start-Sleep -Seconds 1
                    $nodeStatusAfterRestart = CheckJenkinsNodeStatus
                    if ($nodeStatusAfterRestart -eq $true) {
                        Write-Output "Le nœud Jenkins est en ligne après le redémarrage du service. Tout est bon."
                        break
                    }
                }
                if ($nodeStatusAfterRestart -ne $true) {
                    Write-Output "Échec de la vérification du nœud Jenkins après le redémarrage du service."
                }
            } else {
                Write-Output "Échec du redémarrage du service."
            }
        }
    }
    
    # Attendre 5 minutes avant de vérifier à nouveau
    Start-Sleep -Seconds 300
}

# Fin du script
Write-Output "Le script a terminé son travail. Arrêt du script."
exit
