import com.cloudbees.opscenter.server.model.ManagedMaster

// Liste des noms des masters Jenkins à modifier
def mastersToModify = ["p-ilyes-78", "p-nassim-78"]

// Parcourir chaque master et appliquer les modifications si le master existe dans la liste
Jenkins.instance.getAllItems(ManagedMaster.class).each { masterInstance ->
    def nameInstance = masterInstance.fullName
    if (mastersToModify.contains(nameInstance)) {
        changeMasterMemory(masterInstance)
    }
}

def changeMasterMemory(def managedController) {
    def instance = jenkins.model.Jenkins.instanceOrNull.getItemByFullName(managedController.fullName, ManagedMaster.class)
    
    if (instance != null) {
        def configuration = instance.getConfiguration()
        if (configuration != null) {
            def provisioning = configuration.getProvisioning() // Accès à la section Provisioning
            
            // Supposons que la propriété "jenkinsMasterMemoryMb" soit la bonne, mais vous pouvez ajuster le nom de la propriété selon votre configuration.
            def currentMemory = provisioning.jenkinsMasterMemoryMb
            println "Mémoire actuelle pour '${managedController.fullName}': ${currentMemory}MB"
            
            def newMemory = currentMemory + 2048  // Ajouter 2 Go (2048 Mo) à la valeur actuelle
            
            provisioning.jenkinsMasterMemoryMb = newMemory  // Mettre à jour la valeur
            
            instance.setConfiguration(configuration)
            instance.save()
            
            println "RAM pour le master '${managedController.fullName}' mise à jour avec succès à ${newMemory}MB."
        }
    }
}
