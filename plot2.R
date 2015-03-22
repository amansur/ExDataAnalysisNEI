# Read in data files
# Files should be in same directory as script
SCC <- readRDS("Source_Classification_Code.rds")
NEI <- readRDS("summarySCC_PM25.rds")

# subset data to Baltimore's fips code
baltimore <- subset(NEI, fips == "24510")

# create easily plottable objects
x <- levels(factor(baltimore$year))
y <- tapply(baltimore$Emissions, baltimore$year, FUN = sum)

# open graphics device
png("plot2.png", width = 900, height = 600)

# plot data
plot(
    x,
    y,
    type = "b",
    main = expression("Total " * PM[2.5] * " Emissions in Baltimore"),
    xlab = "Year",
    ylab = expression("Emissions ("* PM[2.5] * " in tons)"),
    col = "red",
    lwd = 3
)

# turn device off
dev.off()