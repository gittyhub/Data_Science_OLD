#2
#Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") 
#from 1999 to 2008? Use the base plotting system to make a plot answering this question.

#Checks to see if these files exists, else create them
if(!exists("NEI"))
  {
    NEI <- readRDS("summarySCC_PM25.rds")
  }
if(!exists("SCC"))
  {
    SCC <- readRDS("Source_Classification_Code.rds")
  }

#***We know emission is on the NEI file
#***From the NEI file, look for "fips" where it equals "24510", which is the code for Baltimore
#***create a png

png("plot2.png")

#***Use subset to look for fips that equal "24510", where NEI is the the souce from where we will be subsetting

Baltimorefips <- subset(NEI, fips == "24510")

#***Then we need to sum up total emission by year for this Baltimore data set. Use tappy, pass emission then year
#***from NEI and the funtion, sum, to sum up the emissions by year. This will return the year in column and the sum of 
#***emissions for each year

BaltimoresumD <- tapply(Baltimorefips$Emissions, Baltimorefips$year, sum)

#***Plot the data. names(BaltimoresumD) is the x axis, and the y axis is the year
#***BaltimoresumD is the toal emissions from each year we got from tapply
#***type="l", line type
#***lab, or labels pretty straight forward

plot(names(BaltimoresumD), BaltimoresumD, type="l", xlab = "Year", ylab = "Baltimore total PM2.5 (tons)", main = "Baltimore PM2.5 Levels from 1999 to 2008")
dev.off()