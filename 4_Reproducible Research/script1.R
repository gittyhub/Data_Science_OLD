library(ggplot)
read_activity <- read.csv("activity.csv")
head(read_activity)
class(apply_activity)
class(q)

#----using tapply, returns an array
apply_activity<-tapply(read_activity$steps, read_activity$date, FUN=sum, na.rm=TRUE)
qplot(apply_activity, binwidth=3000,data=activity_DF, xlab = "total number of steps taken each day")
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
apply_activity_A
hist(apply_activity_A$steps)
#find mean
mean(apply_activity_A$steps)
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
#This gives the location, rows, where na's can be found
na_step_row <- which(is.na(read_activity_NoNA[,1]))
#Get the mean of steps
m_steps_4_na <- mean(read_activity_NoNA[,1], na.rm = TRUE)
#Given the location of the rm, in rows, and the column we want to replace is steps, or the first column
read_activity_NoNA[na_v_row, 1] <- m_steps_4_na

#Make a histogram of the total number of steps taken each day and Calculate and report the mean and median 
#total number of steps taken per day. Do these values differ from the estimates from the first part of the 
#assignment? What is the impact of imputing missing data on the estimates of the total daily number of steps?

