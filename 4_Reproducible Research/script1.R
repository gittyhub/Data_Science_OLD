setwd("C:/Users/***/Desktop/R Programing/4_Reproducible Research")
library(ggplot2)
read_activity <- read.csv("activity.csv")
head(read_activity)

#----using tapply, returns an array
apply_activity<-tapply(read_activity$steps, read_activity$date, FUN=sum, na.rm=TRUE)
qplot(apply_activity,binwidth=3000, xlab = "total number of steps taken each day")
#find mean
#find out how many zeros we have
table(apply_activity)[1]
#find total observation in apply_activity
length(apply_activity)
#total observation minus all zero is the number of observation we divid by
tot_observation <- length(apply_activity)-table(apply_activity)[1]
mean_steps_day<- sum(apply_activity)/tot_observation
#find median
#sort the list so that its in order
#take the tail end up until we have observations greater than zero
tail(sort(apply_activity), tot_observation)
median(tail(sort(apply_activity), tot_observation))

#----using aggregate, returns a dataframe
apply_activity_A <-aggregate(steps~date, read_activity, na.rm=TRUE, sum)
class(apply_activity_A)
hist(apply_activity_A$steps)
#find mean
mean(apply_activity_A$steps, na.rm=TRUE)
#find median
median(apply_activity_A$steps)


#if you want to see by day
activity_DF <- data.frame(date=names(apply_activity), steps=apply_activity)
activity_DF

#exercise
#using the above activity_DF, break out by day of the week

#----Q2
#What is the average daily activity pattern?
#Make a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and 
#the average number of steps taken, averaged across all days (y-axis)
#Essentially, same as above but instead of by date its by interval, and we are using mean not sum
apply_activity_Mean <-aggregate(steps~interval, read_activity, na.rm=TRUE, mean)
names(apply_activity_Mean)
plot( apply_activity_Mean$interval, apply_activity_Mean$steps, type="l", xlab="Mean Interval", ylab="Steps", main="Intervals and Steps")
head(apply_activity_Mean)
#Determin which position has the max steps
position <- which.max(apply_activity_Mean[,2])
apply_activity_Mean[position,]
#1. Calculate and report the total number of missing values in the dataset (i.e. the total number of rows with NAs)
sum(is.na(read_activity[,1]))
#likewise
sum(is.na(read_activity$steps))

#Devise a strategy for filling in all of the missing values in the dataset. 
#The strategy does not need to be sophisticated. For example, you could use the 
#mean/median for that day, or the mean for that 5-minute interval, etc.
#-----Strategy-----
#Locate all na values
#Replace those na valuse with the mean of the steps minus the na's

#Create a new dataset that is equal to the original dataset but with the missing data filled in.
#First lets reread the data
read_activity_NoNA <-read.csv("activity.csv")
#From above, locate all na values
class(read_activity_NoNA)
#This gives the location, rows, where na's can be found
na_step_row <- which(is.na(read_activity_NoNA[,1]))
#Get the mean of steps
m_steps_4_na <- mean(read_activity_NoNA[,1], na.rm = TRUE)
#Given the location of the na, in rows, and the column we want to replace is steps, or the first column
read_activity_NoNA[na_step_row, 1] <- m_steps_4_na
head(read_activity_NoNA)
#Make a histogram of the total number of steps taken each day and Calculate and report the mean and median 
#total number of steps taken per day. Do these values differ from the estimates from the first part of the 
#assignment? What is the impact of imputing missing data on the estimates of the total daily number of steps?
sum_na_activity <- aggregate(steps~date,read_activity_NoNA, na.rm=TRUE,sum)
hist(sum_na_activity$steps, xlab = "# Steps with fill NA Values", ylab = "Frequency", main = "Histogram of activity with NA replaced with mean")
mean(sum_na_activity$steps)
median(sum_na_activity$steps)
head(sum_na_activity)

#**For this part the weekdays() function may be of some help here. Use the dataset with the filled-in 
#missing values for this part.

#*Create a new factor variable in the dataset with two levels – “weekday” and “weekend” indicating whether 
#*a given date is a weekday or weekend day.
read_activity_WD <- read_activity_NoNA
head(read_activity_NoNA)
read_activity_WD$date_of_week <-weekdays(as.Date(as.factor(read_activity_WD$date)))
read_activity_WD <- read_activity_WD[,c("steps", "date", "date_of_week", "interval")]
names(read_activity_WD)[names(read_activity_WD)=="date_of_week"] <- "day_of_week"
head(read_activity_WD)
read_activity_WD[,"wday_or_wEnd"] <- ifelse(read_activity_WD$day_of_week == "Saturday" | read_activity_WD$day_of_week == "Sunday", "Weekend", "Weekday")
read_activity_WD <- read_activity_WD[,c(1,2,3,5,4)]
head(read_activity_WD)
agg_activity_WD <- aggregate(steps~date, read_activity_WD, sum, na.rm = TRUE)
names(read_activity_WD)[names(read_activity_WD)=="steps"] <- c("total_steps")


#*Make a panel plot containing a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and 
#*the average number of steps taken, averaged across all weekday days or weekend days (y-axis). 
#*See the README file in the GitHub repository to see an example of what this plot should look like using simulated data.
avg_steps_day <- aggregate(read_activity_WD$total_steps, by=list(read_activity_WD$wday_or_wEnd, read_activity_WD$day_of_week, read_activity_WD$interval), mean)
head(avg_steps_day)
names(avg_steps_day) <- c("wDay_wEnd", "Day_week", "interval", "mean_Steps")
ggplot(avg_steps_day, aes(x=interval, y=mean_Steps))+geom_line(color="blue")+ facet_wrap(~wDay_wEnd, nrow=2, ncol=1)+labs(x="Interval", y="Mean # of steps")



