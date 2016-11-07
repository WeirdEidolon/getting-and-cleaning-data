# Source Data
this information is build on top of that found in the source:  https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip. see features.txt from the source zip file for more information on the values found in analysis.csv.


# Variables in analysis.csv
* subject.id - anonymous code for a participent in the study, ranging from 1 to 30, which servers to anonymize the participants
* activity.name - the name of the activity performed by a subject, one of the following: walking, walking.upstairs, walking.downstairs, sitting, standing, laying. the names have spaces replaced with periods so that they can be used in data frames with the $ operator.
* others - the remaining columns are the averages of multiple readings of the specified statistic for the given subject.id and activity.name. the names are of the form {stat}.{mean|std}. those that have spatial components also have the dimension specified, like {stat}.{mean|std}.{X|Y|Z}.
