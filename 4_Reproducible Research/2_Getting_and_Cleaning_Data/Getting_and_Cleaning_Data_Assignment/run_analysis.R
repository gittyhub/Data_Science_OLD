#***Step 1 Merges the training and the test sets to create one data set

setwd("C:/Users/Herbert/Desktop/R Programing/Getting and Cleaning Data/UCI HAR Dataset")
testX <- read.table("./test/X_test.txt") #nrow(testX)
testY <- read.table("./test/Y_test.txt") #nrow(testy)
testSub <- read.table("./test/subject_test.txt") #nrow(testSub)

trainX <- read.table("./train/X_train.txt") #nrow(trainX)
trainY <- read.table("./train/y_train.txt") #nrow(trainX)
trainSub <- read.table("./train/subject_train.txt") #nrow(trainX)

#***Step 2 Merges the training and the test sets to create one data set

features <- read.table("features.txt", col.names=c("featuresID", "featuresLabel"))
includedFeatures <- grep("-mean\\(\\)|-std\\(\\)", features$featuresLabel) # no space after the or operator or else it wont pick up -std
#brings in the rows number that have mean or std in them
#features of the data set where mean and std can be found

#***Step 3 Uses descriptive activity names to name the activities in the data set

activity <- read.table("activity_labels.txt", col.names=c("activityID", "activityLabel"))
activity$activityLabel <- gsub("_","", as.character(activity$activityLabel))
#activityID and type of activity, walking, stairsup, stairs down, sitting....

#***Step 4 Uses descriptive activity names to name the activities in the data set

MergeSub <- rbind(trainSub,testSub)
#1-30
#attaches testSub to to the last row of trainSub
names(MergeSub) <- "subjectID"
MergeX <- rbind(trainX, testX)
MergeX <- MergeX[,includedFeatures]
#Only select column from MergeX defined by the includedFeatures variable, mean, std
names(MergeX) <- gsub("\\(|\\)", "", features$featuresLabel[includedFeatures])
#for all the nmes in MergeX, substitute "\\(" or "\\)" for "" from the features table in the featuresLabel column, return the row associate with the var includeFeatures
#so includedFeatures has all the names, mean and std, then we only included the columns where the names match for, mean or std, then we assign the actual names of the column using the above code

MergeY <- rbind(trainY, testY)
#Traing labels and test labels
names(MergeY) <- "activityID"
activity1 <- merge(MergeY, activity, by = "activityID")$activityLabel
#merge MergeY by activityID, and only return activityLable column
data <- cbind(MergeSub, MergeX, activity1)
write.table(data,"Merged_Data.txt")

#***Step 5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
library(data.table)
dataDT <- data.table(data)
calculateData <-dataDT[, lapply(.SD,mean), by = c("subjectID", "activity1")]
write.table(calculatedData, "calculatedData.txt")
