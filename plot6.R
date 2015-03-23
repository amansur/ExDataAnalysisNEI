# Read in data files
# Files should be in same directory as script
SCC <- readRDS("Source_Classification_Code.rds")
NEI <- readRDS("summarySCC_PM25.rds")

# Reduce SCC to items containing words "vehicle" or "motor" in EI.Sector column (case insensitive)
vehicleSCC <- SCC[grep("vehicle|motor", SCC$EI.Sector, ignore.case = TRUE),]

# subset data by vehicle SCC codes found above
vehicleSCCEmissions <- NEI[NEI$SCC %in% vehicleSCC$SCC,]

# further subset data to fips codes for LA and Baltimore
baltimoreLAVehicleEmissions <- subset(vehicleSCCEmissions, fips == "24510" | fips == "06037")

# transform data breaking down emissions by fips and year
baltimoreLAVehicleEmissionsSummary <- data.frame(
    year = levels(as.factor(baltimoreLAVehicleEmissions$year)),
    emissions = tapply(baltimoreLAVehicleEmissions$Emissions, 
                       list("Year"=baltimoreLAVehicleEmissions$year, "Fips"=baltimoreLAVehicleEmissions$fips), sum))

# normalize data to show % change
baltimoreLAVehicleEmissionsSummary[,2] <- 100 * baltimoreLAVehicleEmissionsSummary[, 2] / baltimoreLAVehicleEmissionsSummary[1, 2] - 100
baltimoreLAVehicleEmissionsSummary[,3] <- 100 * baltimoreLAVehicleEmissionsSummary[, 3] / baltimoreLAVehicleEmissionsSummary[1, 3] - 100

# load reshape2 library
library(reshape2)

# clean up dataframe
vehicleEmissions <- melt(baltimoreLAVehicleEmissionsSummary)
vehicleEmissions <- transform(vehicleEmissions, 
                              variable = factor(
                                  variable, 
                                  levels=c("emissions.06037", "emissions.24510"), 
                                  labels=c("Los Angeles", "Baltimore")))
colnames(vehicleEmissions) <- c("Year", "City", "Emissions")

# load ggplot2
library(ggplot2)

# plot data
ggplot(vehicleEmissions, aes(Year, Emissions)) + 
    facet_grid(. ~ City) +
    geom_line(aes(group = 1)) +
    xlab("Year") + 
    ylab(expression("% change in " * PM[2.5] * " emissions from 1999")) + 
    ggtitle(expression(PM[2.5] * " emissions from motor vehicle sources relative to 1999"))

# save plot
ggsave(filename = "plot6.png", width = 9, height = 6, units = "in", dpi = 100)