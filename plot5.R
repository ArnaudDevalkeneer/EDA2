
# plot5.R

# How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?

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
NEIBaltimore <- subset(NEI, fips == "24510")

# select specific rows in SCC related to coal 
vehicleflgs <- grepl("Vehicles", SCC$EI.Sector)
vehicleSCC <- SCC[vehicleflgs,]       

# merge NEI and vehicleSCC
library(plyr)
vehicleEmissions <- arrange(join(vehicleSCC,NEIBaltimore),SCC)

# compute vehicle emissions per year in Baltimore
validvehicleEmissions <- vehicleEmissions[ !is.na(vehicleEmissions$Emissions), ]
totalvehicleEmissions <- ddply(validvehicleEmissions, .(year), summarize, emissions=sum(Emissions))

library(ggplot2)
g <- ggplot(totalvehicleEmissions , aes(year,emissions)) + labs(title="Motor Vehicle Emissions in Baltimore",y="Amount of PM2.5 emitted (in tons)") + geom_line() + geom_point(size=4) 
print(g)
dev.copy(png, file="plot5.png")
dev.off()
