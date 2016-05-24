#3
#Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, which of these 
#four sources have seen decreases in emissions from 1999–2008 for Baltimore City? Which have seen increases 
#in emissions from 1999–2008? Use the ggplot2 plotting system to make a plot answer this question.

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
png("plot3.png")

#***Use subset to look for fips that equal "24510", where NEI is the the source from where we will be subsetting

Baltimorefips <- subset(NEI, fips == "24510")

#***Then we need to sum up total emission by year for this Baltimore data set. Use ddply to get output in data.frame format
#***to pass to ggplot. tapply will produce array which ggplot will not handle. Use Baltimorefips as your source, then year and type
#***as your variables, and for function us sum with Emission as your argument. This will return the year, type and emission in 
#***column for all of the year, and the type specified above 

BaltimoresumD <- ddply(Baltimorefips, .(year, type), function(x) sum(x$Emission))
colnames(BaltimoresumD)[3] <- "Emissions"

#***Use ggplot to setup the graph. BaltimoresumD, is the source, for aes, aesthetics, use year for x and Emission for 
#***y, and color by type column.

g <- ggplot(BaltimoresumD, aes(year, Emissions, color = type))
p <- g + geom_line()+guides(col=guide_legend())

#***with facets
#p <- g + geom_line()+facet_wrap(~type)+guides(col=guide_legend())

print(p)
dev.off()