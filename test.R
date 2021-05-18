library(ospsuite)

# Load a simulation
dataPath <- file.path(path.package("ospsuite", quiet = FALSE), "extdata", fsep = .Platform$file.sep)
simFilePath <- file.path(dataPath, "simple.pkml", fsep = .Platform$file.sep)
sim <- loadSimulation(simFilePath)
print(sim)

# # Get the parameter "Dose"
# doseParamPath <- "Applications|IV 250mg 10min|Application_1|ProtocolSchemaItem|Dose"
# doseParam <- getParameter(doseParamPath, sim)

# # Change the dose to 350mg. The values has to be converted to base unit, first
# newValue <- toBaseUnit(quantity = doseParam, values = 350, unit = "mg")
# setParameterValues(parameters = doseParam, values = newValue)

# # Simulate
# simResults <- runSimulation(simulation = sim)
# # Retrieve the results
# simulatedValues <- getOutputValues(simulationResults = simResults)

# # Plot time-concentration profile
# plot(simulatedValues$data$Time, simulatedValues$data$`Organism|PeripheralVenousBlood|Aciclovir|Plasma (Peripheral Venous Blood)`,
# type = "l",
# xlab = "Time [min]",
# ylab = "Concentration [µmol/l]")