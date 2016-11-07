# Data Preparation
1. download https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip to the desired working directory, with the name "UCI HAR Dataset.zip"
2. execute("run_analysis.R")
3. execute run.analysis() in the desired working directory (where the zip file was downloaded to). if the zip file is named something other than in step 1, or it is outside the working directory, the path to the zip file may be provided as an argument, for example: run.analysis("C:\downloads\dataset.zip").
  * the contents of the zip file are extracted to the working directory
  * it may take several minutes to load the data files, as the largest are fixed width format files, which take a long time to read
  * once the data files are read initially, the data will be cached in a csv format file for quicker access the next time the analysis is run
  * the result returned is a dataframe with the averages of the mean and standard deviation features for each subject and activity in the study, the results of which are included in this repo as analysis.csv. see the variables section below for more.


# Variables
* subject.id - anonymous code for a participent in the study, ranging from 1 to 30, which servers to anonymize the participants
* activity.code - numeric code for an activity performed by a subject
  1. walking
  2. walking upstairs
  3. walking downstairs
  4. sitting
  5. standing
  6. laying
* others - the remaining columns are the averages of multiple readings of the specified statistic for the given subject.id and activity.code. the names are of the form {stat}.{mean|std}. those that have spatial components also have the dimension specified, like {stat}.{mean|std}.{X|Y|Z}.
