import jenkins.model.*
import hudson.model.*

// Fonction pour augmenter la mémoire
def addMemory(currentMemory, increment) {
    def unit = currentMemory[-2..-1]
    def currentValue = currentMemory[0..-3].toInteger()
    def incrementValue = increment.toInteger()
    def newValue = currentValue + incrementValue
    return "${newValue}${unit}"
}

// Fonction pour modifier la mémoire des masters Jenkins
def updateMasterMemory(masterName, additionalMemory) {
    def jenkins = Jenkins.instance
    def master = jenkins.getNode(masterName)

    if (master == null) {
        println "No such master node: ${masterName}"
        return
    }

    def launcher = master.getLauncher()
    def config = master.getNodeProperties().get(hudson.slaves.EnvironmentVariablesNodeProperty.class)

    if (config == null) {
        println "No environment variables configured for node: ${masterName}"
        return
    }

    def envVars = config.getEnvVars()
    def currentMemory = envVars.get("JAVA_OPTS") ?: ""
    def newMemory = addMemory(currentMemory, additionalMemory)

    envVars.put("JAVA_OPTS", newMemory)
    println "Updated ${masterName} JAVA_OPTS to: ${newMemory}"
}

// Liste des masters et mémoire à ajouter
def masters = ["master-1", "master-2", "master-3"]
def additionalMemory = "2G" // Mémoire à ajouter

// Mise à jour de chaque master
masters.each { masterName ->
    updateMasterMemory(masterName, additionalMemory)
}

println "Memory update completed."
