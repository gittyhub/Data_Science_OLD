#4
#Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?

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
png("plot4.png")
#***Look for coal emissions
head(SCC)

#***Wil be using EI.Sector, column 4 and matching for all items related to coal
#***Need to merge SCC and NEI, no emissions info on SCC but there is Coal data

SCC_NEI <- merge(SCC, NEI, by = "SCC")
head(SCC_NEI)

#***EI.Sector (coal) is column 4, Emission (emissions output) is the 3rd to last column

length(names(SCC_NEI))

#***Lenght is 20, so Emssion is in column 18
#***Grab all coal data from colum 4. Using grepl to match all entries related to "coal"

coal <- grepl("Coal", SCC_NEI[,4], ignore.case = TRUE)
summary(coal)

#***Pull in all rows with true value from coal agains SCC_NEI, essentiall all rows with coal in column 4, this will be all
#***merged data, realted to coal emission

coal1 <- SCC_NEI[coal,]

#***Then we need to sum up total emission by year for related to coal. Use ddply to get output in data.frame format
#***to pass to ggplot. tapply will produce array which ggplot will not handle. Use caol1 as your source, then year and type
#***as your variables, and for function us sum with Emission as your argument. This will return the year, type and emission in 
#***column for all of the year, and the type specified above 

coalbyYear <- ddply(coal1, .(year, type), function(x) sum(x$Emissions))

#***change the name of the sum column to Emissions

colnames(coalbyYear)[3] <- "Emissions"

#***Use ggplot to setup the graph. coalbyYear, is the source, for aes, aesthetics, use year for x and Emission for 
#***y, and color by type column.

g <- ggplot(coalbyYear, aes(year, Emissions, color = type))
p <- g + geom_line() + ggtitle("Emissions: Coal")
print(p)
dev.off()