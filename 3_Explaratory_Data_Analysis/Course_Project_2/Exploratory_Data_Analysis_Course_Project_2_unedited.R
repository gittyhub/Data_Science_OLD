setwd("C:/Users/Herbert/Desktop/R Programing/Explaratory_Data_Analysis/Lesson 4")
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

sumD <- tapply(NEI$Emissions, NEI$year, sum)

png("plot1.png")
plot(names(sumD), sumD, type="l", xlab = "Year", ylab = "total PM2.5 (tons)", main = "PM2.5 Levels from 1999 to 2008")
dev.off()

png("plot2.png")
Baltimorefips <- subset(NEI, fips == "24510")
BaltimoresumD <- tapply(Baltimorefips$Emissions, Baltimorefips$year, sum)
plot(names(BaltimoresumD), BaltimoresumD, type="l", xlab = "Year", ylab = "Baltimore total PM2.5 (tons)", main = "Baltimore PM2.5 Levels from 1999 to 2008")
dev.off()

library(ggplot2)
library(plyr)
png("plot3.png")
Baltimorefips <- subset(NEI, fips == "24510")
BaltimoresumD <- ddply(Baltimorefips, .(year, type), function(x) sum(x$Emissions))
colnames(BaltimoresumD)[3] <- "Emissions"
qplot(year, Emissions, data= BaltimoresumD, geom = "line", color = type)+ labs(title= "Baltimore PM2.5 Levels Emissions Level by type from 1999 to 2008")
dev.off()


library(ggplot2)
library(plyr)
png("plot3.png")
Baltimorefips <- subset(NEI, fips == "24510")
g <- ggplot(BaltimoresumD, aes(year, Emissions, color = type))
#p <- g + geom_line()+guides(col=guide_legend())
#lines using ggplot
p <- g + geom_line()+facet_wrap(~type)+guides(col=guide_legend())
print(p)


library(ggplot2)
library(plyr)
png("plot4.png")
#Look for coal emissions
head(SCC)
#Wil be using EI.Sector, column 4
#Need to merge SCC and NEI, no emissions info on SCC but there is Coal data
SCC_NEI <- merge(SCC, NEI, by = "SCC")
head(SCC_NEI)
#EI.Sector is column 4, Emission 3rd to last
length(names(SCC_NEI))
#Lenght is 20, so Emssion is 18
#Grab all coal data from colum 4
coal <- grepl("Coal", SCC_NEI[,4], ignore.case = TRUE)
summary(coal)
#coalEmissions <- SCC_NEI[,18][coal]
#length(coalEmissions)
#head(coalEmissions)
#Pull in all rows with true value from coal, essentiall all rows with coal in column 4
coal1 <- SCC_NEI[coal,]
#length(coal1)
#summary(coal1)
#sum up emissions
coalbyYear <- ddply(coal1, .(year, type), function(x) sum(x$Emissions))
summary(coalbyYear)
head(coalbyYear)
#change the name of the sum column to Emissions
colnames(coalbyYear)[3] <- "Emissions"
g <- ggplot(coalbyYear, aes(year, Emissions, color = type))
p <- g + geom_line()
print(p)
dev.off()


library(ggplot2)
library(plyr)
png("plot5.png")
#Meger both data set
SCC_NEI <- merge(SCC, NEI, by = "SCC")
names(SCC_NEI)
Baltimorefips <- subset(SCC_NEI, fips == "24510")
head(Baltimorefips)
length(Baltimorefips)
road <- grepl("^on-road", Baltimorefips$type, ignore.case=TRUE)
head(road)
Bmore1 <- Baltimorefips[road,]
BmorebyYear <- ddply(Bmore1, .(year, type), function(x) sum(x$Emissions))
colnames(BmorebyYear)[3] <- "Emissions"
g <- ggplot(BmorebyYear, aes(year, Emissions, color = type))
p <- g + geom_line()
print(p)
dev.off()


library(ggplot2)
library(plyr)
png("plot6.png")
SCC_NEI <- merge(SCC, NEI, by = "SCC")
names(SCC_NEI)
Bmore_LA_fips <- subset(SCC_NEI, fips == "24510" | fips =="06037")
head(Bmore_LA_fips)
Bmore_LA_Road <- grepl("^on-road", Bmore_LA_fips$type, ignore.case=TRUE)
head(Bmore_LA_Road)
Bmore_LA <- Bmore_LA_fips[Bmore_LA_Road,]
head(Bmore)
Bmore_LA_Esum <- ddply(Bmore_LA, .(year,fips), function(x) sum(x$Emissions))
colnames(Bmore_LA_Esum)[3] <- "Emissions"
head(Bmore_LA_Esum)
Bmore_LA_Esum$fips[Bmore_LA_Esum$fips=="24510"] <- "Baltimore, MD"
Bmore_LA_Esum$fips[Bmore_LA_Esum$fips=="06037"] <- "LA, CA"

g <- ggplot(Bmore_LA_Esum, aes(year, Emissions, color = fips))
p <- g +geom_line()+labs(color="Location")
print(p)
dev.off()








