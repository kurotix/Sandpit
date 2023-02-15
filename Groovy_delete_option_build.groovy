def job = Jenkins.instance.getItem("test-mvn")
def params = job.getProperty(ParametersDefinitionProperty.class)
params.getParameterDefinition("toto").delete()
job.save()
