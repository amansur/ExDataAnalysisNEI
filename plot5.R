# Read in data files
# Files should be in same directory as script
SCC <- readRDS("Source_Classification_Code.rds")
NEI <- readRDS("summarySCC_PM25.rds")

# Reduce SCC to items containing words "vehicle" or "motor" in EI.Sector column (case insensitive)
vehicleSCC <- SCC[grep("vehicle|motor", SCC$EI.Sector, ignore.case = TRUE),]

# subset emissions data first by SCC categories, then by fips region code
baltimoreVehicleEmissions <- NEI[NEI$SCC %in% vehicleSCC$SCC, ]
baltimoreVehicleEmissions <- baltimoreVehicleEmissions[baltimoreVehicleEmissions$fips == "24510", ]

# transform data into easily plottable data frame
baltimoreVehicleEmissionsSummary <- data.frame(
    year = levels(as.factor(baltimoreVehicleEmissions$year)),
    emissions = tapply(baltimoreVehicleEmissions$Emissions, baltimoreVehicleEmissions$year, sum))

# load ggplot
library(ggplot2)

# plot data
ggplot(baltimoreVehicleEmissionsSummary, aes(year, emissions)) + 
    geom_bar(stat = "identity") +
    xlab("Year") + 
    ylab(expression("Emissions " * PM[2.5] * " in tons")) + 
    ggtitle(expression(PM[2.5] * "Emissions from motor vehicle sources in Baltimore 1999 - 2008"))

# save file
ggsave(filename = "plot5.png", width = 9, height = 6, units = "in", dpi = 100)