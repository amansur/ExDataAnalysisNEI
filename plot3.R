# Read in data files
# Files should be in same directory as script
SCC <- readRDS("Source_Classification_Code.rds")
NEI <- readRDS("summarySCC_PM25.rds")

# subset data to just Baltimore fips code
baltimore <- subset(NEI, fips == "24510")

# transform data into easily plottable object
baltimore <- transform(baltimore, type = factor(
        type, levels = c("POINT", "NONPOINT", "ON-ROAD", "NON-ROAD"), 
        labels = c("Point", "Non-point", "Road", "Non-Road")))

# load ggplot
library(ggplot2)

# plot data
ggplot(baltimore, aes(factor(year), Emissions)) + 
    facet_grid(. ~ type) + 
    geom_bar(stat = "identity") + 
    xlab("Year") + 
    ylab(expression("Emissions " * PM[2.5] * " in tons")) + 
    ggtitle(expression(PM[2.5] * "Emissions in Baltimore 1999 - 2008 by type"))

# save plot
ggsave(filename = "plot3.png", width = 9, height = 6, units = "in", dpi = 100)