
# plot3.R

# Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, which of these 
# four sources have seen decreases in emissions from 1999–2008 for Baltimore City? Which have seen increases in 
# emissions from 1999–2008? Use the ggplot2 plotting system to make a plot answer this question.

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
totalEmissionsPerType <- ddply(NEIBaltimore, .(year,type), summarize, emissions=sum(Emissions))

library(ggplot2)
g <- ggplot(totalEmissionsPerType, aes(year,emissions)) + labs(title="Emissions in Batimore city",y="Amount of PM2.5 emitted (in tons)") + geom_line(aes(color=type)) + geom_point(aes(color=type,shape=type),size=4) 
print(g)
dev.copy(png, file="plot3.png")
dev.off()
