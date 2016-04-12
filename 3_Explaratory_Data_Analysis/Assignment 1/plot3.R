ptable <- read.table("household_power_consumption.txt", header = TRUE, sep = ";", stringsAsFactors=FALSE, dec=".", na.strings="?", quote='\"'                                     )

subUsedData <- ptable[ptable$Date %in% c("1/2/2007", "2/2/2007"),]
#1#datetime <- paste(as.Date(data$Date), data$Time)
#2#data$Datetime <- as.POSIXct(datetime)
#3#datetime <- paste(as.Date(subUsedData$Date), subUsedData$Time)
#4#subUsedData$Datetime <- as.POSIXct(datetime)        

subDateTime <- strptime(paste(subUsedData$Date, subUsedData$Time, sep = " "),"%d/%m/%Y %H:%M:%S")
subUsedData$dateTime <- as.POSIXct(subDateTime)
#you need this because strptime give it to you as POSXlt not POSXct which will not plot correctly

with(subUsedData, {
      plot(Sub_metering_1~dateTime, type="l", ylab = "Energy sub metering", xlab = "")
      lines(Sub_metering_2~dateTime, col="Red")
      lines(Sub_metering_3~dateTime, col="Blue")
})

legend("topright", col=c("black", "red", "blue"), lty =1, lwd=2, legend=c("Sub_metering_1", "Sub_metering_2", "Sub_merting_3"))
