## Get all names of features
features <- read.table("UCI HAR Dataset/features.txt")

## Read test data, rename the variable names, and extract only the measurements on the mean and standard deviation.
X_test <- read.table("UCI HAR Dataset/test/X_test.txt")
names(X_test) <- features$V2
X_test <- X_test[, c(grep("mean()", features$V2), grep("std()", features$V2))]

## Combine subject and activity informations
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
X_test$Subject <- subject_test$V1
X_test$ActivityID <- y_test$V1

## Read train data, rename the variable names, and extract only the measurements on the mean and standard deviation.
X_train <- read.table("UCI HAR Dataset/train/X_train.txt")
names(X_train) <- features$V2
X_train <- X_train[, c(grep("mean()", features$V2), grep("std()", features$V2))]

## Combine subject and activity informations
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
X_train$Subject <- subject_train$V1
X_train$ActivityID <- y_train$V1

## Merges the training and the test sets to create one data set
dataset <- rbind(X_test, X_train)

## Uses descriptive activity names to name the activities in the data set
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
names(activity_labels) <- c("ActivityID", "Activity")
dataset <- merge(dataset, activity_labels)

## Create a tidy data set with the average of each variable for each activity and each subject
library(reshape2)
varnames <- features$V2[c(grep("mean()", features$V2), grep("std()", features$V2))]
meltdata <- melt(dataset, id=c("Subject","Activity"), measure.vars = varnames)
tempdata <- dcast(meltdata, Subject + Activity ~ variable, mean)
tidydata <- melt(tempdata, id=c("Subject","Activity"), measure.vars = varnames)

## Output tidy data set as a txt file
write.table(tidydata, file = "tidy_data_set.txt", row.name=FALSE)