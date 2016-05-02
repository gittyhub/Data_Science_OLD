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
using the above activity_DF, break out by day of the week
