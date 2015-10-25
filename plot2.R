
# plot2.R

# Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") from 1999 to 2008? 
# Use the base plotting system to make a plot answering this question.

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

# subset dataframe
NEIBaltimore <- subset(NEI, fips == "24510")

library(plyr)
totalEmissions <- ddply(NEIBaltimore, .(year), summarize, emissions=sum(Emissions))

with(totalEmissions, {
  plot(emissions~year, type="o", lwd=2.5, col='Blue', ylab="Amount of PM2.5 emitted in Baltimore City (in tons)", xlab="year")
})
dev.copy(png, file="plot2.png")
dev.off()
