# Read in data files
# Files should be in same directory as script
SCC <- readRDS("Source_Classification_Code.rds")
NEI <- readRDS("summarySCC_PM25.rds")

# Reduce SCC to items containing words "coal" in Short.Name column (case insensitive)
coalSCC <- SCC[grep("coal", SCC$Short.Name, ignore.case = TRUE),]

# Subset emissions data by SCC codes found above
coalEmissions <- NEI[NEI$SCC %in% coalSCC$SCC,]

# Transform data into easily plottable data frame
coalEmissionsSummary <- data.frame(
    year = levels(as.factor(coalEmissions$year)),
    emissions = tapply(coalEmissions$Emissions, coalEmissions$year, sum))

# load ggplot
library(ggplot2)

# Plot data
ggplot(coalEmissionsSummary, aes(year, emissions)) + 
    geom_bar(stat = "identity") +
    xlab("Year") + 
    ylab(expression("Emissions " * PM[2.5] * " in tons")) + 
    ggtitle(expression(PM[2.5] * "Coal combustion related emissions in the U.S. 1999 - 2008"))

# Save plot
ggsave(filename = "plot4.png", width = 9, height = 6, units = "in", dpi = 100)