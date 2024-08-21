import com.cloudbees.opscenter.server.model.ManagedMaster
import java.util.regex.*

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
            def yaml = configuration.getYaml()
            
            // Affichage du YAML complet pour le débogage
            println "YAML pour '${managedController.fullName}':"
            println yaml
            
            // Expression régulière pour trouver la mémoire actuelle en MB
            Matcher memoryMatcher = Pattern.compile("jenkinsMasterMemoryMb:\\s*(\\d+)").matcher(yaml)
            if (memoryMatcher.find()) {
                def currentMemory = memoryMatcher.group(1).toInteger()
                def newMemory = currentMemory + 2048  // Ajouter 2 Go (2048 Mo) à la valeur actuelle
                
                // Mise à jour de la valeur de la mémoire dans le YAML
                def updatedYaml = yaml.replaceFirst("jenkinsMasterMemoryMb:\\s*\\d+", "jenkinsMasterMemoryMb: ${newMemory}")
                
                // Appliquer la nouvelle configuration YAML
                configuration.setYaml(updatedYaml)
                instance.setConfiguration(configuration)
                instance.save()
                
                println "RAM pour le master '${managedController.fullName}' mise à jour avec succès à ${newMemory}MB."
            } else {
                println "Aucune configuration de RAM trouvée pour '${managedController.fullName}'."
            }
        }
    }
}
