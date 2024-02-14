# Définir le nom de domaine de votre serveur Jenkins
$jenkinsServer = "toto-devops.group"

# Fonction pour vérifier l'état de la connexion avec Jenkins
function CheckConnection {
    $pingResult = Test-Connection -ComputerName $jenkinsServer -Count 1 -Quiet
    return $pingResult
}

# Fonction pour redémarrer les services dont le nom commence par "Jenkins agent"
function RestartServices {
    $services = Get-Service -Name "Jenkins agent*" | Where-Object { $_.Status -ne "Running" }
    if ($services) {
        foreach ($service in $services) {
            Restart-Service -InputObject $service -Force
            Write-Output ("Service " + $service.DisplayName + " redémarré avec succès.")
        }
    }
    else {
        Write-Output "Tous les services Jenkins agent sont déjà en cours d'exécution."
    }
}

# Boucle principale
while ($true) {
    $connectionStatus = CheckConnection
    if (-not $connectionStatus) {
        Write-Output "La connexion avec Jenkins est perdue. Redémarrage des services..."
        RestartServices
    }
    
    # Attendre 5 minutes avant de vérifier à nouveau
    Start-Sleep -Seconds 300
}
