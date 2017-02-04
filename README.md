# Get-and-Clean-Data-Project

You will be required to submit: 
1) a tidy data set as described below, 
2) a link to a Github repository with your script for performing the analysis, and 
3) a code book that describes the variables, the data, and any transformations or work
   that you performed to clean up the data called CodeBook.md. 
4) You should also include a README.md in the repo with your scripts. This repo
   explains how all of the scripts work and how they are connected.
   
##SCRIPT "run_analysis.R" is explained below:
   
##DATA DOWNLOAD
   The script first downloads the data (zipped) from the link below
   "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
   It then unzips the file in the working directory. Subfolders are created.
   
## The dataset includes the following files:


- 'README.txt'

- 'features_info.txt': Shows information about the variables used on the feature vector.

- 'features.txt': List of all features.

- 'activity_labels.txt': Links the class labels with their activity name.

- 'train/subject_train.txt'

- 'train/X_train.txt': Training set.

- 'train/y_train.txt': Training labels.

- 'test/subject_train.txt'

- 'test/X_test.txt': Test set.

- 'test/y_test.txt': Test labels.

##MERGE DATA
The script continues, and merges the training and the test sets to create one data set.
*combine subject data from train and test folders
*combine "x" data from train and test folders
*combine "y" data from train and test folders
*merge the columns of the subject, X and Y data.tables
The final merge is contained in object "allData"

##EXTRACT MEAN AND STD DEVIATION DATA
Extracts only the measurements on the mean and standard deviation for each measurement.
First searches the :features.txt" file for the feature names containing "mean" or "std".
Places all mean and std data , along with subject and Y data into object "meanstd"

##DESCRIPTIVE ACTIVITY NAMES
The script adds descriptive activity names to name the activities in the data set
names are taken from file "activity_labels.txt"
and merged with the "meanstd" oject.

##DESCRIPTIVE VARIABLE NAMES ADDED
Appropriately labels the data set with descriptive variable names.
feature names are taken from the fData object (source: "features.txt")
some data cleaning of labels with the "gsub" function is performed.
the names are added into the meanstd object cotaining all the data.

##TIDY DATA SET
A second, independent tidy data set with the average  of each variable for each
activity and each subject are completed.
The IDs "Subject","ActivityID","Activites" are melted along with the measurement variables
to create object "dMelt"
The dcast function is used on dMelt to reshape the data into object tData (and tData.txt is output)

/end

