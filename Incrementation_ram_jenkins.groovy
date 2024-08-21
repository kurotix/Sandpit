import com.cloudbees.opscenter.server.model.ManagedMaster
import java.util.regex.*

// Liste des noms des masters Jenkins à modifier
def mastersToModify = ["p-ilyes-78", "p-nassim-78"]

// Parcourir chaque master dans la liste et appliquer les modifications si le master existe
mastersToModify.each { masterName ->
    def masterNode = Jenkins.instance.getAllItems(ManagedMaster.class).find { it.fullName == masterName }
    if (masterNode) {
        changeRequestsMemory(masterNode)
    } else {
        println "Master '${masterName}' introuvable."
    }
}

def changeRequestsMemory(def managedMaster) {
    def configuration = managedMaster.getConfiguration()
    if (configuration != null) {
        def yaml = configuration.getYaml()

        // Trouver et mettre à jour la valeur de la mémoire dans `limits` et `requests`
        yaml = updateMemoryInYaml(yaml, "limits")
        yaml = updateMemoryInYaml(yaml, "requests")

        // Appliquer la nouvelle configuration YAML
        configuration.setYaml(yaml)
        managedMaster.setConfiguration(configuration)
        managedMaster.save()

        println "RAM pour le master '${managedMaster.fullName}' mise à jour avec succès."
    }
}

def updateMemoryInYaml(def yaml, def key) {
    // Expression régulière pour trouver la mémoire dans la section `limits` ou `requests`
    Matcher memoryMatcher = Pattern.compile("${key}:\\s*\\{.*memory:\\s*\"([0-9]+)\\.000000[MmGg]\"").matcher(yaml)
    if (memoryMatcher.find()) {
        def currentMemoryValue = memoryMatcher.group(1).toInteger()

        // Ajouter 2048M (2G) à la valeur actuelle
        def newMemoryValue = currentMemoryValue + 2048

        // Créer la nouvelle chaîne de mémoire
        def newMemoryString = "${key}: {memory: \"${newMemoryValue}.000000M\""

        // Remplacer la valeur de la mémoire dans le YAML
        yaml = yaml.replaceAll("${key}:\\s*\\{.*memory:\\s*\"[0-9]+\\.000000[MmGg]\"", newMemoryString)
    } else {
        println "Aucune configuration de RAM trouvée pour '${key}'."
    }
    return yaml
}
