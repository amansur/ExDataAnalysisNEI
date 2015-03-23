# Read in data files
# Files should be in same directory as script
SCC <- readRDS("Source_Classification_Code.rds")
NEI <- readRDS("summarySCC_PM25.rds")

# subset data to Baltimore's fips code
baltimore <- subset(NEI, fips == "24510")

# create easily plottable objects
emissions <- tapply(baltimore$Emissions, baltimore$year, FUN = sum)

# open graphics device
png("plot2.png", width = 900, height = 600)

# plot data
barplot(
    emissions,
    main = expression("Total " * PM[2.5] * " Emissions in Baltimore"),
    xlab = "Year",
    ylab = expression("Emissions ("* PM[2.5] * " in tons)"),
    col = "red",
)

# turn device off
dev.off()