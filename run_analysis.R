# run_analysis.R

# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

# 1 Merges the training and the test sets to create one data set.
# 2 Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3 Uses descriptive activity names to name the activities in the data set
# 4 Appropriately labels the data set with descriptive variable names. 
# 5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each 
# subject.

# Declare directory path relative to current working directory
DataFilePath <- file.path("./data")
# Create data directory if it does not exist
if(!file.exists(DataFilePath)){dir.create(DataFilePath)}
# URL of data file
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
# File Path  and file name to save data file to.
DataFilePathName <- file.path(DataFilePath, "FUCI HAR Dataset.zip")
# Download data file
download.file(url, DataFilePathName)
# Untip compressed data file
unzip(zipfile=DataFilePathName,exdir=DataFilePath)

# Get list of data files with relative path information
DataFiles<-list.files(DataFilePath, recursive=TRUE)

# View the list of Data Files
View(DataFiles)

