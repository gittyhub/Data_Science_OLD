#5
#How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?

#Checks to see if these files exists, else create them
if(!exists("NEI"))
  {
    NEI <- readRDS("summarySCC_PM25.rds")
  }
if(!exists("SCC"))
  {
    SCC <- readRDS("Source_Classification_Code.rds")
  }

library(ggplot2)
library(plyr)

#***create a png
png("plot5.png")

#Meger both data set
SCC_NEI <- merge(SCC, NEI, by = "SCC")

#***Use subset to look for fips that equal "24510", where NEI is the the source from where we will be subsetting

Baltimorefips <- subset(SCC_NEI, fips == "24510")

#***For vehicls we are going to use on-road. We got that from question three where, type variable was listed
#***as type point, nonpoint, onroad, nonroad
road <- grepl("^on-road", Baltimorefips$type, ignore.case=TRUE)

#***from road, we apply that to Baltimorefips, to return all rows where roads match
BmoreRoad <- Baltimorefips[road,]

#***Then we need to sum up total emission by year for this road data set. Use ddply to get output in data.frame format
#***to pass to ggplot. tapply will produce array which ggplot will not handle. Use BmoreRoad as your source, then year and type
#***as your variables, and for function us sum with Emission as your argument. This will return the year, type and emission in 
#***column for all of the year, and the type specified above 

BmorebyYear <- ddply(BmoreRoad, .(year, type), function(x) sum(x$Emissions))
colnames(BmorebyYear)[3] <- "Emissions"


#***Use ggplot to setup the graph. BmoreYEar, is the source, for aes, aesthetics, use year for x and Emission for 
#***y, and color by type column.

g <- ggplot(BmorebyYear, aes(year, Emissions, color = type))
p <- g + geom_line()+ggtitle("Baltimore Motor Vehicle Emissions")
print(p)
dev.off()




