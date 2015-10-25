
# plot4.R

# Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?

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

# select specific rows in SCC related to coal 
coalflgs <- grepl("coal", SCC$SCC.Level.Three) # or use feature SCC$Short.Name
coalSCC <- SCC[coalflgs,]       

# merge NEI and coalSCC
library(plyr)
coalEmissions <- arrange(join(coalSCC,NEI),SCC)

# compute coal emissions per year
totalcoalEmissions <- ddply(coalEmissions, .(year), summarize, emissions=sum(Emissions))

library(ggplot2)
g <- ggplot(totalcoalEmissions, aes(year,emissions)) + labs(title="Coal Combustion-related Emissions in US",y="Amount of PM2.5 emitted (in tons)") + geom_line() + geom_point(size=4) 
print(g)
dev.copy(png, file="plot4.png")
dev.off()
