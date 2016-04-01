#Codebook

1. Download data from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
2. Unzip into R working directory
3. Load test data, y, x, subject
4. Load train data, y, x, subject
5. Load features data, this is where we find mean and std info
6. Load activity data, this is where we see activities, like walking, stairsup, stairsdown, sitting...
7. Merge with rbind y, x and subject for both train and test
8. Calculate the mean and write output

