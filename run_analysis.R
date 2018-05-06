# 1.Merges the training and the test sets to create one data set.
# 2.Extracts only the measurements on the mean and standard deviation for each measurement.
# 3.Uses descriptive activity names to name the activities in the data set
# 4.Appropriately labels the data set with descriptive variable names.
# 5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

subject_train <- read.table("subject_train.txt")
X_train <- read.table("X_train.txt")
y_train <- read.table("y_train.txt")

subject_test <- read.table("subject_test.txt")
X_test <- read.table("X_test.txt")
y_test <- read.table("y_test.txt")

names(subject_train) <- "subjectID"
names(subject_test) <- "subjectID"

featureNames <- read.table("features.txt")
names(X_train) <- featureNames$V2
names(X_test) <- featureNames$V2

names(y_train) <- "activity"
names(y_test) <- "activity"

train <- cbind(subject_train, y_train, X_train)
test <- cbind(subject_test, y_test, X_test)
combined <- rbind(train, test)

meanstdcols <- grepl("mean\\(\\)", names(combined)) | grepl("std\\(\\)", names(combined))

meanstdcols[1:2] <- TRUE

combined <- combined[, meanstdcols]

combined$activity <- factor(combined$activity, 
                            labels=c("Walking",
                                     "Walking Upstairs", 
                                     "Walking Downstairs", 
                                     "Sitting", 
                                     "Standing", 
                                     "Laying"))

melted <- melt(combined, id=c("subjectID","activity"))
tidy <- dcast(melted, subjectID+activity ~ variable, mean)

write.table(tidy, "TIDYresult.txt",row.names = FALSE)
