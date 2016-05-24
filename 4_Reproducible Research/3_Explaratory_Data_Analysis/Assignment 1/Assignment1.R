
ptable <- read.table("household_power_consumption.txt", header = TRUE, sep = ";", stringsAsFactors=FALSE, dec=".")
#read table from the extracted zip file
#header, because there was a header line
#stringAsFactor false becasue if not data will be factor will need to convert again to plot
#sep, ; is what separated the header
#dec is the character used in the file for decimal points

subUsedData <- ptable[ptable$Date %in% c("1/2/2007", "2/2/2007"),]
#from ptable$Data, where 1/2/2007 and 2/2/2007 in (%in%) ptable$Data 
#alternatively
subUsedData1 <- subset(ptable, ptable$Date == "1/2/2007" | ptable$Date == "2/2/2007")
#remember the subset function uses logical parameter

subUsedData$Time <- strptime(subUsedData$Time, "%H:%M:%S")
subUsedData$Date <- as.Date(subUsedData$Date, format = "%m/%d/%Y")
subDateTime <- strptime(paste(subUsedData$Date, subUsedData$Time, sep = " "),"%d/%m/%Y %H:%M:%S")

globalActivePower <- as.numeric(subUsedData$Global_active_power)

png("plot1.png", width = 480, height = 480)
hist(globalActivePower, col = "red", main = "Global Active Power", ylab = "Frequency", xlab = "Global Active Power (kilowatts))")
dev.off()

plot(subDateTime, globalActivePower, type = "l")




subSetData <- ptable[ptable$Date %in% c("1/2/2007","2/2/2007") ,]

#str(subSetData)
datetime <- strptime(paste(subSetData$Date, subSetData$Time, sep=" "), "%d/%m/%Y %H:%M:%S") 
globalActivePower <- as.numeric(subSetData$Global_active_power)
png("plot2.png", width=480, height=480)
plot(datetime, globalActivePower, type="l", xlab="", ylab="Global Active Power (kilowatts)")
