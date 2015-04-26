# run_analysis.R

###########################################################################################################################################
# The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data 
# that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be 
# required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, 
# and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called 
# CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how 
# they are connected. 
#
# One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like 
# Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course 
# website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the 
# site where the data was obtained:
#
# http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
#
# Here are the data for the project:
#
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
#
# You should create one R script called run_analysis.R that does the following. 
#
# 1) Merges the training and the test sets to create one data set.
# 2) Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3) Uses descriptive activity names to name the activities in the data set
# 4) Appropriately labels the data set with descriptive variable names. 
# 5) From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each 
# subject.
###########################################################################################################################################

###########################################################################################################################################
# Goal 1 Merge the training and the test sets to create one data set.

# Declare directory path relative to current working directory to save the temporary working data files to.
DataFilePath <- file.path("./data")

# Create data directory if it does not exist
if(!file.exists(DataFilePath)){dir.create(DataFilePath)}

# URL of source data file
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

# File Path  and file name to save data file to.
DataFilePathName <- file.path(DataFilePath, "UCI HAR Dataset.zip")

# Download data file
download.file(url, DataFilePathName)

# Unzip compressed data file
unzip(zipfile=DataFilePathName,exdir=DataFilePath)

# Get list of data files with relative path information
DataFiles<-list.files(DataFilePath, recursive=TRUE)

# View the list of Data Files to confirm successfull extraction from compressed file and files are accessable to subsequent code logic. 
View(DataFiles)

# Aggrigate together the test and train files for each set of data of interest for this project

# ** NOTE: You must bind each set of files in same order for example *test then *train versions for all the resulting column values to be 
# grouped in correct row order.

# subject ids are found hte in the subject_test.txt and subject_train.txt files. 
dfSubject  <- rbind(read.table(file.path(DataFilePath, "UCI HAR Dataset\\test" , "subject_test.txt"),header = FALSE),
                    read.table(file.path(DataFilePath, "UCI HAR Dataset\\train", "subject_train.txt"),header = FALSE))

# activity ids are found the in the Y_test.txt and Y_train.txt files. 
dfActivity<- rbind(read.table(file.path(DataFilePath, "UCI HAR Dataset\\test" , "Y_test.txt" ),header = FALSE),
                   read.table(file.path(DataFilePath, "UCI HAR Dataset\\train", "Y_train.txt"),header = FALSE))

# feauture mesurements are found the in the X_test.txt and X_train.txt files. 
dfFeatures  <- rbind(read.table(file.path(DataFilePath, "UCI HAR Dataset\\test" , "X_test.txt"),header = FALSE),
                     read.table(file.path(DataFilePath, "UCI HAR Dataset\\train", "X_train.txt"),header = FALSE))

# Use column binding to combine the individual data frames into one consolidated data set 
Data <- cbind(dfSubject, dfActivity, dfFeatures)

# Review the resulting data set to confirm we have achived goal #1 
View(Data)

###########################################################################################################################################
# Goal 2 Extract only the measurements on the mean and standard deviation for each measurement. 

# Descriptive names for dfFeature columns is found in the "features.txt" file. 
dfFeaturesNames <- read.table(file.path(DataFilePath, "UCI HAR Dataset", "features.txt"),head=FALSE)

# Name the consolidated data set columns so that we can find the dfFeatures measures associated wit mean and standard measurements
names(Data)<- c("subject", "activityId", as.vector(dfFeaturesNames$V2))


# Build Index of column names subject, activity  and measures that contain "mean()" or "std()" text
iColumns <- c("subject", "activityId", as.vector(dfFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dfFeaturesNames$V2)]))
# Reveiw iColumn index values to confirm thay conatin desired intermediate results
View(iColumns)

# subset our orginal data frame to only the columns in our index of values to extract.
Data<-subset(Data,select=iColumns)

# Review the resulting data set to confirm we have achived goal #2
View(Data)

###########################################################################################################################################
# Goal #3: Use descriptive activity names to name the activities in the data set

# Descriptors for activity ids in the Y_test and Y_train files is found in the activity_labels.txt file. 
dfActivityLabels <- read.table(file.path(DataFilePath, "UCI HAR Dataset", "activity_labels.txt"),head=FALSE)

# Reveiw data frame values to confirm they loaded successfully
View(dfActivityLabels)

# Set column names to create common "activityId" column between data frames for applending "activity" description to consolidated data set
names(dfActivityLabels)<- c("activityId", "activity")

# Use the merge function to append the activity column from the dfActivityLabels data frame with the the value associated with the 
# activityID value in each row of the Data dataframe.
Data = merge(Data,dfActivityLabels,by='activityId',all.x=TRUE);

# Remove activityID column  in column position 1 from Data data frame as it is no longer needed.
Data <- subset(Data, select = -c(1))

# Review the resulting data set to confirm we have achived Goal #3
View(Data)

###########################################################################################################################################
# 4 Appropriately labels the data set with descriptive variable names. 



###########################################################################################################################################
# 5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each 
# subject.

