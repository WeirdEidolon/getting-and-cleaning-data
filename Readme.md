# run.analysis(data.zip.file="UCI HAR Dataset.zip")
entry point for script: unzips data, loads it, performs analysis and returns result.
if the zip data file does not have the deafult name or is a directory other than the working directory, it can be specified as an argument.

# load.data()
responsible for unzipping, loading and cleaning data. a cached verison of the data is saved to speed up subsequent load times.

# load.data.set()
load the training or test data set.

# load.subjects()
load a subjects file.

# load.activities()
load the activities file.

# load.activity.labels()
load the activity codes and names from file.

# load.features()
read the various measurements that constitute the featuers in the data set. they are named with the results of load.feature.names().

# load.feature.names()
read the feature columnd indices and names that correspond to the feature files. the names are cleaned to remove parenthesis and non-alphanumeric characters, usually replaced with periods so that they can be used with the dataframe $ operator.
