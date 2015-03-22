SCC <- readRDS("Source_Classification_Code.rds")
NEI <- readRDS("summarySCC_PM25.rds")

x <- levels(factor(NEI$year))
y <- tapply(NEI$Emissions, NEI$year, FUN = sum)

png("plot1.png", width = 900, height = 600)

plot(
    x,
    y,
    type = "b",
    main = expression("Total " * PM[2.5] * " Emissions in the U.S."),
    xlab = "Year",
    ylab = expression("Emissions ("* PM[2.5] * " in tons)"),
    col = "red",
    lwd = 3
)

dev.off()