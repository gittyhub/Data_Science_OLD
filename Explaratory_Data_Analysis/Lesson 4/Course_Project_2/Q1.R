#1
#Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? Using the base plotting system, make a plot 
#showing the total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008.

#Checks to see if these files exists, else create them
if(!exists("NEI"))
  {
    NEI <- readRDS("summarySCC_PM25.rds")
  }
if(!exists("SCC"))
  {
    SCC <- readRDS("Source_Classification_Code.rds")
  }

#***From the NEI data set, looking to see the total emission and its related year
#***Then we need to sum up total emission by year for this data set. Use tappy, pass emission then year
#***from NEI and the funtion, sum, to sum up the emissions by year. This will return the year in column and the sum of 
#***emissions for each year
#***This can also be done with aggregate funtion, aggregatedTotalByYear <- aggregate(Emissions ~ year, NEI, sum)

sumD <- tapply(NEI$Emissions, NEI$year, sum)

#***create a png

png("plot1.png")

#***Plot the data. names(BaltimoresumD) is the x axis, and the y axis is the year
#***1999,2002,2005,2008.
#***sumD is the toal emissions from each year we got from tapply
#***type="l", line type
#***lab, or labels pretty straight forward

plot(names(sumD), sumD, type="l", xlab = "Year", ylab = "total PM2.5 (tons)", main = "PM2.5 Levels from 1999 to 2008")
dev.off()