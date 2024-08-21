import com.cloudbees.opscenter.server.model.ManagedMaster

// Lister tous les Managed Masters gérés par CJOC
Jenkins.instance.getAllItems(ManagedMaster.class).each { master ->
    println "Managed Master Name: ${master.name}"
}
