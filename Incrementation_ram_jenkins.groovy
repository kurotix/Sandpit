import com.cloudbees.opscenter.server.model.ManagedMaster

def increaseMemory = { memoryMB, incrementGB ->
    return memoryMB + (incrementGB * 1024)
}

def updateMemoryForMasters = { masterNames, incrementGB ->
    masterNames.each { masterName ->
        def master = Jenkins.instance.getAllItems(ManagedMaster.class).find { it.name == masterName }

        if (master != null) {
            println "Updating Memory for Master: ${master.name}"

            // Lire la valeur actuelle de la mémoire
            def currentMemoryMB = master.getProperties().get(com.cloudbees.opscenter.server.model.JM2MemoryLimit).getMemoryLimitMB()
            println "Current Memory for ${master.name}: ${currentMemoryMB} MB"

            // Augmenter la mémoire de 2G
            def newMemoryMB = increaseMemory(currentMemoryMB, incrementGB)
            println "New Memory for ${master.name}: ${newMemoryMB} MB"

            // Mettre à jour la nouvelle valeur de mémoire
            master.getProperties().get(com.cloudbees.opscenter.server.model.JM2MemoryLimit).setMemoryLimitMB(newMemoryMB)

            master.save()
            println "Memory updated to ${newMemoryMB} MB for ${master.name}"

            // Redémarrer le Managed Master pour appliquer les changements
            master.doSafeRestart()
            println "Master ${master.name} is restarting..."
        } else {
            println "No such master found: ${masterName}"
        }
    }
}

def masterNames = ["p-ilyes-78", "p-nassim-78"]
def incrementGB = 2 // Ajouter 2 Go

updateMemoryForMasters(masterNames, incrementGB)

println "Memory update completed for selected masters."
