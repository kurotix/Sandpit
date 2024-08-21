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

        // Trouver la valeur actuelle de la mémoire
        Matcher subMatcher = Pattern.compile("memory:\\s*\"([0-9]+)([mMgG])\"").matcher(yaml)
        if (subMatcher.find()) {
            def currentMemoryValue = subMatcher.group(1).toInteger()
            def currentMemoryUnit = subMatcher.group(2).toLowerCase()

            // Convertir la mémoire en GB si nécessaire
            if (currentMemoryUnit == 'm') {
                currentMemoryValue = currentMemoryValue / 1024
            }

            // Ajouter 2 Go à la mémoire actuelle
            def newMemoryValue = currentMemoryValue + 2

            // Créer la nouvelle chaîne de mémoire avec le format correct
            def newMemoryString = "memory: \"${newMemoryValue}g\""

            // Remplacer la valeur de la mémoire dans le YAML
            def yamlNew = yaml.replaceAll("memory:\\s*\"[0-9]+[mMgG]\"", newMemoryString)

            // Appliquer la nouvelle configuration YAML
            configuration.setYaml(yamlNew)
            managedMaster.setConfiguration(configuration)
            managedMaster.save()

            println "RAM pour le master '${managedMaster.fullName}' mise à jour à ${newMemoryValue} Go"
        } else {
            println "Aucune configuration de RAM trouvée pour '${managedMaster.fullName}'."
        }
    }
}
