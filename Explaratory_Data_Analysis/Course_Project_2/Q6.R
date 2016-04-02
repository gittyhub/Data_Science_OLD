#5
#Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in Los Angeles County, 
#California (fips == "06037"). Which city has seen greater changes over time in motor vehicle emissions?

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
png("plot6.png")

#***Meger both data set

SCC_NEI <- merge(SCC, NEI, by = "SCC")

#***
Use subset to look for fips that equal "24510" and "06037", where SCC_NEI is the the source from where we will be subsetting

Bmore_LA_fips <- subset(SCC_NEI, fips == "24510" | fips =="06037")

#***For motor vehicls we are going to use on-road. We got that from question three where, type variable was listed
#***as type point, nonpoint, onroad, nonroad.
Bmore_LA_Road <- grepl("^on-road", Bmore_LA_fips$type, ignore.case=TRUE)

#***from Bmore_LA_Road, we apply that to Bmore_LA_fips, to return all rows where Bmore_LA_Road matches in Bmore_LA_fips
Bmore_LA <- Bmore_LA_fips[Bmore_LA_Road,]


#***Then we need to sum up total emission by year for this road data set. Use ddply to get output in data.frame format
#***to pass to ggplot. tapply will produce array which ggplot will not handle. Use Bmore_LA as your source, then year and type
#***as your variables, and for function us sum with Emission as your argument. This will return the year, type and emission in 
#***column for all of the year, and the type

Bmore_LA_Esum <- ddply(Bmore_LA, .(year,fips), function(x) sum(x$Emissions))
colnames(Bmore_LA_Esum)[3] <- "Emissions"

#***From Bmore_LA_Esum, in the fips column, change city code to its respectable name. This way when you graph, in the legend you will
#***get the name and not the city code
Bmore_LA_Esum$fips[Bmore_LA_Esum$fips=="24510"] <- "Baltimore, MD"
Bmore_LA_Esum$fips[Bmore_LA_Esum$fips=="06037"] <- "LA, CA"

#***Use ggplot to setup the graph. Bmore_LA_Esum, is the source, for aes, aesthetics, use year for x and Emission for 
#***y, and color by type column.
g <- ggplot(Bmore_LA_Esum, aes(year, Emissions, color = fips))
p <- g +geom_line()+labs(color="Location") + ggtitle("Baltimore vs LA Emissions")
print(p)
dev.off()

