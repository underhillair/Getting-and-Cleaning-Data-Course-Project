setwd("~/Documents/Steve Personal Documents/Work/Online Coursework/R Programming JH")

#creates text file with headers based on UCI files, 
headers <- read.table("./UCI HAR Dataset/features.txt")

#downloads activity mapping from UCI, adds headers
activity <- read.table("./UCI HAR Dataset/activity_labels.txt")
colnames(activity) <- c("Activity_ID","Activity_Label")

#downloads training data from three UCI files.  Adds headers.
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
colnames(subject_train) <- "Subject_ID"
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
colnames(X_train) <- headers[,2]
Y_train <- read.table("./UCI HAR Dataset/train/Y_train.txt")
colnames(Y_train) <- "Activity_ID"
Data_train <- cbind(subject_train, Y_train, X_train)

#downloads test data from three UCI files.  Adds headers.
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
colnames(subject_test) <- "Subject_ID"
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
colnames(X_test) <- headers[,2]
Y_test <- read.table("./UCI HAR Dataset/test/Y_test.txt")
colnames(Y_test) <- "Activity_ID"
Data_test <- cbind(subject_test, Y_test, X_test)

#step 1: merges the training and test sets
Data_total <- rbind(Data_train, Data_test)

#step 2: extracts only the measurements on mean and standard deviation.
#        IDs headers with "mean" or "std" in the title.  Adds subject and activity IDs.
#        Keeps only those columns identified.
headers_Subset <- c("Subject_ID", "Activity_ID",
    grep("mean()", colnames(X_test), value = TRUE),
    grep("std()", colnames(X_test), value = TRUE))
Data_total2 <- Data_total[,headers_Subset]

#step 3: uses descriptive activity names by merging UCI mapping for activity then replacing Activity_ID with Activity_Name.
Data_total2 <- merge(x = Data_total2, y = activity, by = "Activity_ID", all.x = TRUE)
Data_total2 <- Data_total2[ , !(names(Data_total2) =="Activity_ID")]
Data_total2 <- Data_total2 <- Data_total2[ ,c(1,81,2:80)]
write.table(Data_total2,"./UCI HAR Dataset/Getting and Cleaning Data Course Project/Mobile_Tech_Study_Complete.txt" )

#step 4: addressed when downloading training and test sets and adding decriptive variable names.

#step 5: Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
Data_means <- group_by(Data_total2, Subject_ID, Activity_Label)
Data_means <- summarise_each(Data_means, funs(mean))
write.table(Data_means,"./UCI HAR Dataset/Getting and Cleaning Data Course Project/Mobile_Tech_Study_Summary.txt" )

#test that data was uploaded correctly
data <- read.table("./UCI HAR Dataset/Getting and Cleaning Data Course Project/Mobile_Tech_Study_Complete.txt", header = TRUE)
