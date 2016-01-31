setwd("C:/MyData/Learning/Coursera/JohnsHopkins/GitProjects/Getting_and_Cleaning_Data")
rm(list = ls())

###########################################################
## Part 1: Read in the test and training data            ##
###########################################################

## Import libraries that will be used in this script
library(dplyr)

## Clean up the environment to ensure there is no stale data
rm(list = ls())

## The first thing to do is to load in the test data files
## Load is the subject_test.txt file and process
subject_test <- read.table("./test/subject_test.txt",
                           sep = " ",
                           header = FALSE)

## Convert subject test using tbl_df
## Rename the first column to reflect that it represents the subject id
subject_test_df <- tbl_df(subject_test)
subject_test_df <-  
  select(subject_test_df, subjectId = V1) 

## Load is the x_test.txt file and convert using tbl_df
## Column names will be added later
x_test <- read.table("./test/X_test.txt",
                     header = FALSE)

## Convert x test using tbl_df
x_test_df <- tbl_df(x_test)

## Load in the y_test.txt file and process
y_test <- read.csv("./test/y_test.txt",
                   header = FALSE)

## Rename the first column to reflect that it represents the label
names(y_test) <- "activity"


## Repeat for the training files
subject_train <- read.table("./train/subject_train.txt",
                            sep = " ",
                            header = FALSE)

## Convert subject train using tbl_df
## Rename the first column to reflect that it represents the subject id
subject_train_df <- tbl_df(subject_train)
subject_train_df <-  
  select(subject_train_df, subjectId = V1)

## Load is the x_train.txt file and convert using tbl_df
## Column names will be added later
x_train <- read.table("./train/X_train.txt",
                     header = FALSE)

## Convert x train using tbl_df
x_train_df <- tbl_df(x_train)

## Load in the y_train.txt file and process
y_train <- read.csv("./train/y_train.txt",
                   header = FALSE)

## Convert y train using tbl_df
## Rename the first column to reflect that it represents the label
names(y_train) <- "activity"

## Bind the individual training and test datasets
subjects <- bind_rows(subject_train_df, subject_test_df)
lables <- rbind(y_train, y_test)
data <- bind_rows(x_train_df, x_test_df)

#######################################################################
## Part 1: Complete                                                  ##
## All the test / training data is now available                     ##
##    - subject_test_df:  The subject id for each test record        ##
##    - y_test_df:        The label for each test record             ##
##    - x_test_df:        The observes data for the test records     ##
##    - subject_train_df: The subject id for each training record    ##
##    - y_train_df:       The label for each training record         ##
##    - x_train_df:       The observes data for the training records ##
##    - data:             x_train_df, x_test_df combined             ##
##    - labels:           y_train_df, y_test_df combined             ##
##    - subjects:         subject_train_df, subject_test_df combined ##
#######################################################################

##############################################################  
## Part 2: Isolate mean and standard deviation measurements ##
## Part 4: Appropriately labels the data set                ##
##############################################################

## Read in the features and convert to dplyr dataframe
features <- read.table("./features.txt",
                       sep = " ",
                       header = FALSE)

## We have to extract the locations of the variables that contain only
##    - mean values mean()
##    - standard deviation values std()
##    - features that just contain the string mean are ignored
mean_std_locations <- grep("mean\\(\\)|std\\(\\)", features[, 2])

## Use the locations as indices to strip out unwanted features
data <- data[, mean_std_locations]

## Now we need to clean up the column names of the data data frame
## First name the columns
names(data) <- features[mean_std_locations, 2]
## remove the brackets
names(data) <- gsub("\\(\\)", "", names(data)) 
## Change mean to Mean and std to Std to match the CamelCase of the other text
names(data) <- gsub("mean", "Mean", names(data)) 
names(data) <- gsub("std", "Std", names(data))
## Remove the -
names(data) <- gsub("-", "", names(data)) 

## At this point could start replacing acc with Acceleration etc.
## I have decided not to as in my opinion the feature / column names 
## are now fine

#######################################################################
## Part 1 & 4: Complete                                              ##
## We have on the features wanted and all features / columns are     ##
##    descriptively names                                            ##
##    - data is now 10299 obs. * 66 variables                        ##
#######################################################################

##############################################################  
## Part 3: Uses descriptive activity names in the data set  ##
##############################################################

## Read in the activity descriptive names
activities <- read.table("./activity_labels.txt",
                         sep = " ",
                         header = FALSE)

## Going to follow the same CamelCase type naming convention
## First convert to lower case
activities[, 2] <- tolower(activities[, 2])
## Remove the underscores
activities[, 2] <- gsub("_", "", activities[, 2])
## All activities are single words except 2nd and 3rd activities 
substr(activities[2, 2], 8, 8) <- toupper(substr(activities[2, 2], 8, 8))
substr(activities[3, 2], 8, 8) <- toupper(substr(activities[3, 2], 8, 8))

## Now lookup each active to create descriptive names
## These descriptive values are then assigned back to the label data frame
descriptive_activities <- activities[lables[, 1], 2]
lables[, 1] <- descriptive_activities

## Join the separate data frames together to create the final dataset
final_dataset <- bind_cols(subjects, lables, data)

## Write out the final dataset
write.table(final_dataset, "./cleaned_data.txt")


#####################################################################  
## Part 5: Create tidy data set with the average of each variable  ##
#####################################################################

## First group by subject id and activity
final_dataset_grouped <- group_by(final_dataset, subjectId, activity)

## Then for each of the remaining columns calculate the mean
tidy_dataset <- summarise_each(final_dataset_grouped, funs(mean))

## Write out the tidy dataset
write.table(tidy_dataset, 
            "./tidy_data.txt",
            row.name=FALSE)



