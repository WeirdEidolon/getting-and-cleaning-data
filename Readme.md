# Summary
this code summarizes movement and position data collected in a sutdy for wearble devices, producing a dataset that contains the averages of each mean and standard deviation statistic for each subject and activity from the original dataset.

# Files
* analysis.csv - the resulting processed sensor data. see below for more details on the contents.
* CodeBook.md - this file. describes the procedure for producing analysis.csv and its contents.
* Readme.md - describes the basic operation of each function in run_analysis.R.
* run_analysis.R - the R code file that analyzes the sensor data.

# Data Preparation
1. download https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip to the desired working directory, with the name "UCI HAR Dataset.zip"
2. execute("run_analysis.R")
3. execute run.analysis() in the desired working directory (where the zip file was downloaded to). if the zip file is named something other than in step 1, or it is outside the working directory, the path to the zip file may be provided as an argument, for example: run.analysis("C:\downloads\dataset.zip").
  * the contents of the zip file are extracted to the working directory
  * it may take several minutes to load the data files, as the largest are fixed width format files, which take a long time to read.
  * once the data files are read initially, the data will be cached in a csv format file for quicker access the next time the analysis is run, in cache.csv. to re-run from scratch, simply delete cache.csv.
  * the result returned is a dataframe with the averages of the mean and standard deviation features for each subject and activity in the study, the results of which are included in this repo as analysis.csv. see the variables section below for more.

# Function Summary
## run.analysis(data.zip.file="UCI HAR Dataset.zip")
entry point for script: unzips data, loads it, performs analysis and returns result.
if the zip data file does not have the deafult name or is a directory other than the working directory, it can be specified as an argument.

## load.data()
responsible for unzipping, loading and cleaning data. a cached verison of the data is saved to speed up subsequent load times.

## load.data.set()
load the training or test data set.

## load.subjects()
load a subjects file.

## load.activities()
load the activities file.

## load.activity.labels()
load the activity codes and names from file.

## load.features()
read the various measurements that constitute the featuers in the data set. they are named with the results of load.feature.names().

## load.feature.names()
read the feature columnd indices and names that correspond to the feature files. the names are cleaned to remove parenthesis and non-alphanumeric characters, usually replaced with periods so that they can be used with the dataframe $ operator.
