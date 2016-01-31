# Getting and Cleaning Data Course Project

Assignment: Getting and Cleaning Data Course Project

This file describes how the run_analysis.R script in the root of this project works.

* It is assumed that the test and train folders from the project data are available in the same folder as the run_analysis.R script. It is also assumed that "activity_labels.txt" and the "features.txt" files are also located in the same folder as run_analysis.R. If necessasy the data can be downloaded from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip.
* Assuming that RStudion is being used set the working directory to point at the folder where run_analysis.R is located and open the script (you may have to update the setwd() command at the begining of the file).
* Select all the code in the script and run. Two output files are generated in the current working directory:
** cleaned_data.txt: (10299*68 dimension)
** tidy_data.txt: 180*68 dimension.

