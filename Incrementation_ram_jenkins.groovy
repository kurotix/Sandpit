import com.cloudbees.opscenter.server.model.ManagedMaster
import java.util.regex.*

// Liste des noms des masters Jenkins à modifier
def mastersToModify = ["p-ilyes-78", "p-nassim-78"]

// Parcourir chaque master et appliquer les modifications si le master existe dans la liste
Jenkins.instance.getAllItems(ManagedMaster.class).each { masterInstance ->
    def nameInstance = masterInstance.fullName
    if (mastersToModify.contains(nameInstance)) {
        changeRequestsMemory(masterInstance)
    }
}

def changeRequestsMemory(def managedController) {
    def instance = jenkins.model.Jenkins.instanceOrNull.getItemByFullName(managedController.fullName, ManagedMaster.class)
    
    if (instance != null) {
        def configuration = instance.getConfiguration()
        if (configuration != null) {
            def yaml = configuration.getYaml()

            // Trouver et mettre à jour la valeur de la mémoire
            Matcher subMatcher = Pattern.compile("memory:\\s*\"([0-9]+)\\.000000[MmGg]\"").matcher(yaml)
            if (subMatcher.find()) {
                def memoryReq = subMatcher.group(1).toInteger()
                def newMemoryReq = memoryReq + 2048  // Ajouter 2 Go à la valeur actuelle
                
                // Remplacer l'ancienne valeur par la nouvelle
                def yamlNew = yaml.replaceAll("memory:\\s*\"[0-9]+\\.000000[MmGg]\"", "memory: \"${newMemoryReq}.000000M\"")
                
                // Appliquer la nouvelle configuration YAML
                configuration.setYaml(yamlNew)
                instance.setConfiguration(configuration)
                instance.save()
                
                println "RAM pour le master '${managedController.fullName}' mise à jour avec succès à ${newMemoryReq}M."
            } else {
                println "Aucune configuration de RAM trouvée pour '${managedController.fullName}'."
            }
        }
    }
}
