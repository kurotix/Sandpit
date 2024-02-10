# Spécifiez le chemin du dossier sur lequel vous souhaitez modifier les autorisations
$dossier = "C:\chemin\vers\votre\dossier"

# Récupérez le compte "Local System Account"
$localSystemAccount = New-Object System.Security.Principal.NTAccount("NT AUTHORITY\System")

# Récupérez les autorisations actuelles sur le dossier
$autorisations = Get-Acl -Path $dossier

# Créez un nouvel objet FileSystemAccessRule pour définir les autorisations
$nouvelleAutorisation = New-Object System.Security.AccessControl.FileSystemAccessRule($localSystemAccount,"FullControl","Allow")

# Ajoutez les nouvelles autorisations aux autorisations existantes
$autorisations.AddAccessRule($nouvelleAutorisation)

# Appliquez les autorisations modifiées au dossier
Set-Acl -Path $dossier -AclObject $autorisations
