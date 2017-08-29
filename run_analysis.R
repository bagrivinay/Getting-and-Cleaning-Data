## Downloadin the zip files
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")

##unzipping the file
unzip(zipfile="./data/Dataset.zip",exdir="./data")

## Defining file path
files_path <- file.path("./data" , "UCI HAR Dataset")

## Reading Data
ActivityTrain_Data <- read.table(file.path(files_path, "train", "Y_train.txt"),header = FALSE)
ActivityTest_Data  <- read.table(file.path(files_path, "test" , "Y_test.txt" ),header = FALSE)

SubjectTrain_Data <- read.table(file.path(files_path, "train", "subject_train.txt"),header = FALSE)
SubjectTest_Data  <- read.table(file.path(files_path, "test" , "subject_test.txt"),header = FALSE)

FeaturesTrain_Data <- read.table(file.path(files_path, "train", "X_train.txt"),header = FALSE)
FeaturesTest_Data  <- read.table(file.path(files_path, "test" , "X_test.txt" ),header = FALSE)

## Merging data
Subject_Data <- rbind(SubjectTrain_Data, SubjectTest_Data)
Activity_Data<- rbind(ActivityTrain_Data, ActivityTest_Data)
Features_Data<- rbind(FeaturesTrain_Data, FeaturesTest_Data)

## Associating Columns names to data
names(Subject_Data)<-c("subject")
names(Activity_Data)<- c("activity")
FeaturesNames_Data <- read.table(file.path(files_path, "features.txt"),heade=FALSE)
names(Features_Data)<- FeaturesNames_Data$V2

## Combining datasets
Combined_Data <- cbind(Subject_Data, Activity_Data)
Data <- cbind(Features_Data, Combined_Data)

## Finding the measurements on the mean and standard deviation 
FeaturesNames_Sub_Data<-FeaturesNames_Data$V2[grep("mean\\(\\)|std\\(\\)", FeaturesNames_Data$V2)]

## Creating the subset data
Names_Selected<-c(as.character(FeaturesNames_Sub_Data), "subject", "activity" )
Subset_Data<-subset(Data,select=Names_Selected)

## Descriptive activity names to name the activities in the data set
activityLabels <- read.table(file.path(files_path, "activity_labels.txt"),header = FALSE)
Subset_Data$activity <- factor(Subset_Data$activity, levels = activityLabels[,1], labels = activityLabels[,2])
Subset_Data$subject <- as.factor(Subset_Data$subject)

## Appropriately labels the data set with descriptive variable names
names(Subset_Data)<-gsub("^t", "time", names(Subset_Data))
names(Subset_Data)<-gsub("^f", "frequency", names(Subset_Data))
names(Subset_Data)<-gsub("Acc", "Accelerometer", names(Subset_Data))
names(Subset_Data)<-gsub("Gyro", "Gyroscope", names(Subset_Data))
names(Subset_Data)<-gsub("Mag", "Magnitude", names(Subset_Data))
names(Subset_Data)<-gsub("BodyBody", "Body", names(Subset_Data))

## Creating the Tidy dataset and downloading
library(plyr);
Second_Data<-aggregate(. ~subject + activity, Subset_Data, mean)
Second_Data<-Second_Data[order(Second_Data$subject,Second_Data$activity),]
write.table(Second_Data, file = "tidydata.txt",row.name=FALSE, quote = FALSE)
