import jenkins.model.Jenkins
import hudson.slaves.DumbSlave

// Liste des noms des masters Jenkins
def masters = ["p-ilyes-78", "p-nassim-78"]

// Parcourir chaque master dans la liste
masters.each { masterName ->
    // Récupérer l'objet Slave (agent) correspondant au master
    def masterNode = Jenkins.instance.getNode(masterName)
    
    if (masterNode) {
        // Récupérer la configuration existante de la RAM (Xmx)
        def jvmOptions = masterNode.getLauncher().getLaunchCommand()
        
        // Extraire la valeur actuelle de la RAM à partir des options JVM
        def ramOptionMatch = jvmOptions.find(/-Xmx(\d+)([mMgG])/)
        if (ramOptionMatch) {
            def currentRamValue = ramOptionMatch[1].toInteger()
            def currentRamUnit = ramOptionMatch[2].toLowerCase()

            // Calculer la nouvelle RAM (ajouter +2G)
            def newRamValue = currentRamUnit == 'g' ? currentRamValue + 2 : (currentRamValue / 1024) + 2
            def newRamOption = "-Xmx${newRamValue}g"

            // Mettre à jour les options JVM avec la nouvelle valeur de RAM
            jvmOptions = jvmOptions.replaceAll(/-Xmx\d+[mMgG]/, newRamOption)
            masterNode.getLauncher().setLaunchCommand(jvmOptions)

            // Enregistrer la configuration mise à jour
            masterNode.save()

            println "RAM pour le master '${masterName}' mise à jour avec succès : ${newRamOption}"
        } else {
            println "RAM non trouvée pour le master '${masterName}'. Aucune modification effectuée."
        }
    } else {
        println "Master '${masterName}' introuvable. Aucune modification effectuée."
    }
}

// Redémarrer les nodes pour appliquer les changements si nécessaire
masters.each { masterName ->
    def masterNode = Jenkins.instance.getNode(masterName)
    if (masterNode) {
        masterNode.toComputer().disconnect(new hudson.slaves.OfflineCause.ByCLI("Mise à jour de la RAM"))
        masterNode.toComputer().connect(true)
    }
}

println "Script terminé."
