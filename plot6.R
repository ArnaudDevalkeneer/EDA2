
# plot6.R

# Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in Los Angeles County, California (fips == "06037"). 
# Which city has seen greater changes over time in motor vehicle emissions?

# tested in Kubuntu 15.04, R version 3.1.2, Rstudio version 0.99.484

# create data directory 
sourcedir <- dirname(sys.frame(1)$ofile)
setwd(sourcedir)
if (!file.exists("Data")) {
  dir.create("Data")
}

# download and unzip the dataset file
dataset_url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
dataset_localfile <- "./Data/Dataset.zip"
if (!file.exists(dataset_localfile)) {
  download.file( url=dataset_url, destfile=dataset_localfile)
  utils::unzip(dataset_localfile, exdir = "Data")
}

# read the two files
NEI <- readRDS("./Data/summarySCC_PM25.rds")
SCC <- readRDS("./Data/Source_Classification_Code.rds")

# select data fro, baltimore city
NEIInterest <- subset(NEI, (fips == "24510") | (fips == "06037") )

# select specific rows in SCC related to coal 
vehicleflgs <- grepl("Vehicles", SCC$EI.Sector)
vehicleSCC <- SCC[vehicleflgs,]       

# merge NEI and vehicleSCC
library(plyr)
vehicleEmissions <- arrange(join(vehicleSCC,NEIInterest),SCC)
vehicleEmissions$Place <- factor(vehicleEmissions$fips, levels = c("24510","06037"), labels = c("Baltimore City","Los Angeles County, California"))

# compute vehicle emissions per year
validvehicleEmissions <- vehicleEmissions[ !is.na(vehicleEmissions$Emissions), ]
totalvehicleEmissions <- ddply(validvehicleEmissions, .(year,Place), summarize, emissions=sum(Emissions))

library(ggplot2)
g <- ggplot(totalvehicleEmissions , aes(year,emissions)) + labs(title="Motor Vehicle Emissions Comparison",y="Amount of PM2.5 emitted (in tons)") + geom_line(aes(color=Place)) + geom_point(aes(color=Place,shape=Place),size=4) + facet_grid(Place~., space = "free", scales = "free")  
print(g)
dev.copy(png, file="plot6.png")
dev.off()
