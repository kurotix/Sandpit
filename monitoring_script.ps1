# Définir les informations d'identification pour accéder à Jenkins avec un token d'API
$jenkinsUsername = "votre_nom_utilisateur"
$jenkinsAPIToken = "votre_token_api"
$jenkinsCredential = New-Object System.Management.Automation.PSCredential ($jenkinsUsername, (ConvertTo-SecureString -String $jenkinsAPIToken -AsPlainText -Force))

# Définir le chemin d'accès aux dossiers des maîtres Jenkins sur le disque E:
$jenkinsFoldersPath = "E:\jenkins-p-*"

# Fonction pour extraire les noms des maîtres Jenkins à partir des noms de dossier
function GetJenkinsMasterNames {
    param ($jenkinsFoldersPath)
    $jenkinsFolders = Get-ChildItem -Path $jenkinsFoldersPath -Directory
    $jenkinsMasterNames = @()
    foreach ($folder in $jenkinsFolders) {
        $masterName = $folder.Name.Replace("jenkins-p-", "")
        $jenkinsMasterNames += $masterName
    }
    return $jenkinsMasterNames
}

# Fonction pour construire les URL API et les noms de service pour chaque maître Jenkins
function BuildMasterInfo {
    param ($masterName)
    $jenkinsAPIURL = "https://toto-devops.group/p-$masterName/api/json"
    $serviceNom = "jenkins-slave-p-$masterName"
    return @{
        NomDossier = "jenkins-p-$masterName"
        URLAPI = $jenkinsAPIURL
        ServiceNom = $serviceNom
    }
}

# Obtenir les noms des maîtres Jenkins
$jenkinsMasterNames = GetJenkinsMasterNames -jenkinsFoldersPath $jenkinsFoldersPath

# Construire les informations pour chaque maître Jenkins
$masters = @()
foreach ($masterName in $jenkinsMasterNames) {
    $masterInfo = BuildMasterInfo -masterName $masterName
    $masters += $masterInfo
}

# Fonction pour vérifier l'état du nœud Jenkins
function CheckJenkinsNodeStatus {
    param ($urlAPI)
    try {
        # Exécuter une requête HTTP GET vers l'API Jenkins pour obtenir l'état du nœud
        $response = Invoke-RestMethod -Uri $urlAPI -Method Get -Credential $jenkinsCredential

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
    param ($serviceName)
    # Ajoutez ici le code pour redémarrer le service sur votre VM
    # Par exemple :
    Restart-Service -Name $serviceName -Force
}

# Vérifier le statut de chaque maître Jenkins
foreach ($master in $masters) {
    $nodeStatus = CheckJenkinsNodeStatus -urlAPI $master.URLAPI
    if ($nodeStatus -eq $true) {
        Write-Output "Le nœud Jenkins pour le maître $($master.NomDossier) est en ligne et a le label 'windows_58'. Tout est bon. Arrêt du script."
    } else {
        Write-Output "Le nœud Jenkins pour le maître $($master.NomDossier) est hors ligne ou n'a pas le bon label. Redémarrage des services..."
        $restartResult = RestartVMService -serviceName $master.ServiceNom
        if ($restartResult -eq $true) {
            Write-Output "Le redémarrage du service pour le maître $($master.NomDossier) a été effectué avec succès. Vérification du statut du nœud Jenkins après le redémarrage du service..."
            $nodeStatusAfterRestart = CheckJenkinsNodeStatus -urlAPI $master.URLAPI
            if ($nodeStatusAfterRestart -eq $true) {
                Write-Output "Le nœud Jenkins pour le maître $($master.NomDossier) est en ligne après le redémarrage du service. Tout est bon."
            } else {
                Write-Output "Échec de la vérification du nœud Jenkins pour le maître $($master.NomDossier) après le redémarrage du service."
            }
        } else {
            Write-Output "Échec du redémarrage du service pour le maître $($master.NomDossier)."
        }
    }
}

# Fin du script
Write-Output "Le script a terminé son travail. Arrêt du script."
exit
