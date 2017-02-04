# The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set.
# The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers 
# on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data
# set as described below, 2) a link to a Github repository with your script for performing the analysis,
# and 3) a code book that describes the variables, the data, and any transformations or work that you
# performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with
# your scripts. This repo explains how all of the scripts work and how they are connected.
# 
# One of the most exciting areas in all of data science right now is wearable computing - see for 
# example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most 
# advanced algorithms to attract new users. The data linked to from the course website represent data 
# collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available 
# at the site where the data was obtained:
#         http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
# 
# Here are the data for the project:
#         https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
# 
# You should create one R script called run_analysis.R that does the following.
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set with the average 
#    of each variable for each activity and each subject.

setwd("C:\\Users\\George\\Documents\\Learning Books\\Data Science\\Coursera DataScience\\C3 Data Cleaning\\Final Project")

library(data.table)  # load library data.table

fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

download.file( fileURL, destfile="zippedFile.zip", mode ="wb")

file <- unzip("zippedFile.zip")                # unzip downloaded file

fName <- unlist(strsplit(file[1],"/"))[2] # this gets folder name

trainDir  <- paste0(fName,"/train")               # Create training folder object

testDir   <- paste0(fName,"/test")                # Create testing folder object

# The dataset includes the following files:
# =========================================
#         
# - 'README.txt'
# 
# - 'features_info.txt': Shows information about the variables used on the feature vector.
# 
# - 'features.txt': List of all features.
# 
# - 'activity_labels.txt': Links the class labels with their activity name.
#
# - 'train/subject_train.txt'
# 
# - 'train/X_train.txt': Training set.
# 
# - 'train/y_train.txt': Training labels.
#
# - 'test/subject_train.txt'
# 
# - 'test/X_test.txt': Test set.
# 
# - 'test/y_test.txt': Test labels.

# 1. Merges the training and the test sets to create one data set.
##################################################################

# combine subject data from train and test folders
sTrainPath <- paste0(trainDir,"/subject_train.txt")    # Path to the subject training file
sTestPath <- paste0(testDir,"/subject_test.txt")       # Path to the subject test  file
dtSTrain  <- data.table(read.table(sTrainPath))    # create data table for training data
dtSTest   <- data.table(read.table(sTestPath))     # create data table for testing data
# now add subject test data.table to bottom of training subject data.table
dtSubject  <- rbind(dtSTrain, dtSTest)
# setnames operates on data.table and data.frame not other types like list and vector.
setnames(dtSubject, "V1", "subject")  # old, new


# combine "x" data from train and test folders
xTrainPath <- paste0(trainDir,"/X_train.txt")    # Path to the subject training file
xTestPath <- paste0(testDir,"/X_test.txt")       # Path to the subject test  file
dtXTrain  <- data.table(read.table(xTrainPath))    # create data table for training data
dtXTest   <- data.table(read.table(xTestPath))     # create data table for testing data
# now add subject test data.table to bottom of training subject data.table
dtX  <- rbind(dtXTrain, dtXTest)
## No setnames, the x columns shall remain V1, V2, V3, etc. 


# combine "y" data from train and test folders
yTrainPath <- paste0(trainDir,"/Y_train.txt")    # Path to the subject training file
yTestPath <- paste0(testDir,"/Y_test.txt")       # Path to the subject test  file
dtYTrain  <- data.table(read.table(yTrainPath))    # create data table for training data
dtYTest   <- data.table(read.table(yTestPath))     # create data table for testing data
# now add subject test data.table to bottom of training subject data.table
dtY  <- rbind(dtYTrain, dtYTest)
setnames(dtY, "V1", "y") # old, new

# merge the columns of the subject, X and Y data.tables
allData<- cbind(dtSubject,dtX,dtY)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
############################################################################################

fData  <- fread(paste0(fName,"/features.txt"))  # read in 561 featurs names    
# > head(fData, 20)
# V1                  V2
# 1:  1   tBodyAcc-mean()-X
# 2:  2   tBodyAcc-mean()-Y
# 3:  3   tBodyAcc-mean()-Z
# 4:  4    tBodyAcc-std()-X
# 5:  5    tBodyAcc-std()-Y
# 6:  6    tBodyAcc-std()-Z
# 7:  7    tBodyAcc-mad()-X . . .

positionMS   <- grep("mean|std",fData$V2)     # Find positions of the mean and standard deviation variables
positionMS1  <- grep("mean|std",fData$V2) +1  # add +1 because first column of allData is 'subject'
# num [1:79] 2 3 4 5 6 7 42 43 44 45 ...

t(positionMS) # transpose rows to columns for matching later
t(positionMS1)

meanstd <- allData [, c(1, positionMS1, 563), with = FALSE] # create data,table (using data frame way)

# > str(meanstd)
# Classes ‘data.table’ and 'data.frame':	10299 obs. of  81 variables:
#         $ subject: int  1 1 1 1 1 1 1 1 1 1 ...
# $ V1     : num  0.289 0.278 0.28 0.279 0.277 ...



# 3. Uses descriptive activity names to name the activities in the data set
##########################################################################

activityPath <- paste0(fName,"/activity_labels.txt")   # create path object

activityNames<- fread(activityPath)                    # read file into object

names(activityNames) <- c("y", "Activities")  # set column names
# > head(activityNames)
#     y         Activities
# 1:  1            WALKING
# 2:  2   WALKING_UPSTAIRS
# 3:  3 WALKING_DOWNSTAIRS
# 4:  4            SITTING
# 5:  5           STANDING
# 6:  6             LAYING

setkey(activityNames,y)       # set key to y "activity number"

setkey(meanstd, y)            # 'y' is already the activity number 1-6 in meanstd
# > head(meanstd$y)
# [1] 1 1 1 1 1 1

meanstd <- merge(meanstd,activityNames) # Merge by the key of each data   
# > names(meanstd)
# [1] "y"          "subject"    "V1"         "V2"         "V3"         "V4" . . .
# [78] "V539"       "V542"       "V543"       "V552"       "Activities"

# 4. Appropriately labels the data set with descriptive variable names.
##########################################################################

featMS <- fData$V2[positionMS]   
#> head(featNames)
# [1] "tBodyAcc-mean()-X" "tBodyAcc-mean()-Y" "tBodyAcc-mean()-Z" "tBodyAcc-std()-X"  "tBodyAcc-std()-Y" 
# [6] "tBodyAcc-std()-Z" . . . [79]

featNames <- c("ActivityID", "Subject", featMS, "Activites")

featNames <- gsub("BodyBody","Body",featNames)

names(meanstd) <- featNames

# 5. From the data set in step 4, creates a second, independent tidy data set with the average 
#    of each variable for each activity and each subject. (reshaping)
############################################################################

mVNames <- names(meanstd)[3:(length(meanstd)-1)] # the measure variables do not include first 2 and last column

dMelt    <- melt(meanstd, id = c("Subject","ActivityID","Activites"), measure.vars = mVNames)
# > str(dMelt)
# Classes ‘data.table’ and 'data.frame':	813621 obs. of  5 variables:
# $ Subject   : int  1 1 1 1 1 1 1 1 1 1 ...
# $ ActivityID: int  1 1 1 1 1 1 1 1 1 1 ...
# $ Activites : chr  "WALKING" "WALKING" "WALKING" "WALKING" ...
# $ variable  : Factor w/ 79 levels "tBodyAcc-mean()-X",..: 1 1 1 1 1 1 1 1 1 1 ...
# $ value     : num  0.282 0.256 0.255 0.343 0.276 ...

tData   <- dcast(dMelt, Subject + Activites ~ variable, mean)
# > head(tData, 20)
# Subject          Activites tBodyAcc-mean()-X tBodyAcc-mean()-Y tBodyAcc-mean()-Z tBodyAcc-std()-X tBodyAcc-std()-Y
# 1:       1             LAYING         0.2215982      -0.040513953       -0.11320355      -0.92805647     -0.836827406
# 2:       1            SITTING         0.2612376      -0.001308288       -0.10454418      -0.97722901     -0.922618642
# 3:       1           STANDING         0.2789176      -0.016137590       -0.11060182      -0.99575990     -0.973190056

write.table(tData, paste0(fName,"/tData.txt"),row.name=FALSE)

#end
