import com.cloudbees.opscenter.server.model.ManagedMaster

// Fonction pour augmenter la mémoire
def increaseMemory(configXml, increment) {
    return configXml.replaceAll(/-Xmx(\d+)g/, { match, x -> "-Xmx${x.toInteger() + increment}g" })
}

// Liste des Managed Masters à modifier
def masters = ["p-ilyes-78", "p-nassim-78"]
def increment = 2 // Ajouter 2G de RAM

masters.each { masterName ->
    def master = Jenkins.instance.getAllItems(ManagedMaster.class).find { it.name == masterName }

    if (master != null) {
        println "Modifying Master: ${master.name}"

        // Obtenir la configuration actuelle du Managed Master
        def configXml = master.getConfigFile().asString()
        println "Current Config for ${masterName}: \n$configXml"

        // Augmenter la mémoire de 2G
        def updatedConfigXml = increaseMemory(configXml, increment)

        // Appliquer la nouvelle configuration
        master.getConfigFile().write(updatedConfigXml)
        master.save()

        println "Updated Memory for ${masterName}."

        // Optionnel : Redémarrer le Managed Master pour appliquer les changements
        master.doSafeRestart()
        println "Master ${masterName} is restarting..."
    } else {
        println "No such master found: ${masterName}"
    }
}

println "Memory update completed for selected masters."
