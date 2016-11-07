library(reshape2)

load.feature.names <- function(feature.names.file) {
    # load the names and column numbers of the features. this file is headerless, 
    # the column of the feature is listed in the first column and the name of the
    # feature is in the second column and the fields are separated by spaces.
    print(paste("loading feature names file:", feature.names.file))
    df.features = read.csv(feature.names.file, header=FALSE, sep=" ", strip.white=TRUE)
    
    # name the columns
    names(df.features) <- c("columns", "names")
    print(paste("loaded", nrow(df.features), "feature names"))
    
    # we only need the means and standard deviations
    df.features <- df.features[ grep("mean\\(\\)|std\\(\\)", df.features$names), ]
    print(paste("extracted", nrow(df.features), "mean and standard deviation feature names"))
    
    # remove leading and trailing white space by removing and replacing  problematic characters
    # with periods. multiple consecutive characters are collapsed to a single period. this will
    # allow us to use the $ operator to access the data.
    # for example tGravityAcc-mean()-Z  =>  tGravityAcc.mean.Z
    
    # remove leading and trailing characters
    df.features$names <- gsub("^[ (),_-]+|[ (),_-]+$", "", df.features$names)
    
    # replace characters in the middle of the name
    df.features$names <- gsub("[ (),_-]+", ".", df.features$names)
    
    # assert that we only have alpha numeric or period characters for names.
    # this should never happen assuming we cleaned up the names correctly.
    stopifnot( all( grepl("^[a-zA-Z0-9.]+$", df.features$names) ) )
    
    # return the data frame
    df.features
}

load.features <- function(features.file, df.features) {
    # read the feature file. this file is headerless and has features stored in 561 fixed width 
    # columns, 16 characters wide, including the separating spaces.
    print(paste("loading feature file:", features.file))
    
    # build a vector of the column widths
    column.widths <- numeric(561)
    column.widths[] <- 16
    
    # read the fixed width file
    df.data <- read.fwf(features.file, header=FALSE, column.widths)
    
    # extract just the requested columns
    df.data <- df.data[, df.features$columns]
    
    # name the columns
    names(df.data) <- df.features$names
    
    # return the data frame
    df.data
}

load.activity.labels <- function(activity.labels.file) {
    # read the activity labels file. this file is headerless and space separated, the first column
    # is the numeric code for the activity and the second is the name of the activity.
    print(paste("loading activity labels file:", activity.labels.file))
    df.labels <- read.csv(activity.labels.file, header=FALSE, sep=" ", strip.white=TRUE)
    
    # name the columns
    names(df.labels) <- c("codes", "names")
    
    # conver the names to lowercase and replace underscores with periods
    df.labels$names <- tolower( gsub("_+", ".", df.labels$names) )
    
    # the codes are assumed to be the row index, check
    stopifnot( all( df.labels$codes == 1:nrow(df.labels) ) )
    
    # return the data frame
    df.labels
}

load.activities <- function(activities.file, df.activity.labels) {
    # read the activities file. this file is headerless and only has a single column, a numeric 
    # code for the activity corresponding to a feature vector.
    print(paste("loading activities file:", activities.file))
    df.activities <- read.csv(activities.file, header=FALSE, strip.white=TRUE)
    
    # create a column with the activity names
    df.activities <- cbind(df.activities, df.activity.labels$names[df.activities$V1])
    
    # name the columns
    names(df.activities) <- c("activity.code", "activity.name")
    
    # return the data frame
    df.activities
}

load.subjects <- function(subjects.file) {
    # read the subjects file. this file is headerless and only has a single column, a numeric
    # code for the subject performing an activity corresponding to a feature vector.
    print(paste("loading subjects file:", subjects.file))
    df.subjects <- read.csv(subjects.file, header=FALSE, strip.white=TRUE)
    
    # name the column
    names(df.subjects) <- "subject.id"
    
    # return the data frame
    df.subjects
}

load.data.set <- function(activity.labels.file, feature.names.file,
                          subjects.file, activities.file, features.file) {
    # load all files associated with a training or tersting dataset, including the subject,
    # activity and feature data. this function just passes file names to load functions and 
    # combines the results into a single data frame.
    
    # load labels and feature names
    df.activity.labels <- load.activity.labels(activity.labels.file)
    df.feature.names <- load.feature.names(feature.names.file)
    
    # load the dataset, using the labels and feature names to re-label data and name columns
    df.data.set <- cbind( load.subjects(subjects.file),
                          load.activities(activities.file, df.activity.labels),
                          load.features(features.file, df.feature.names) )
    
    # return the data frame
    df.data.set
}

load.data <- function(data.zip.file="UCI HAR Dataset.zip",
                      activity.labels.file="UCI HAR Dataset/activity_labels.txt",
                      feature.names.file="UCI HAR Dataset/features.txt",
                      train.subjects.file="UCI HAR Dataset/train/subject_train.txt",
                      train.features.file="UCI HAR Dataset/train/X_train.txt",
                      train.activities.file="UCI HAR Dataset/train/y_train.txt",
                      test.subjects.file="UCI HAR Dataset/test/subject_test.txt",
                      test.features.file="UCI HAR Dataset/test/X_test.txt",
                      test.activities.file="UCI HAR Dataset/test/y_test.txt") {
                      
    if (file.exists("cache.csv")) {
        # load the cached csv dataset if it has been generated
        print("loading cached dataset")
        df.all.data <- read.csv("cache.csv")
        
        # write.csv added an X column for the row index, we can drop that
        df.all.data <- df.all.data[, !(names(df.all.data) %in% "X")]
    } else {
        unzip(data.zip.file)
    
        df.all.data <- rbind( 
                load.data.set(activity.labels.file, feature.names.file,
                              train.subjects.file, train.activities.file, train.features.file),
                load.data.set(activity.labels.file, feature.names.file,
                              test.subjects.file, test.activities.file, test.features.file) )
        
        # save the data in csv format, which can be read muuuuuuuch faster than the original fixed
        # width data files
        write.csv(df.all.data, "cache.csv", row.names=FALSE)
    }

    df.all.data
}

run.analysis <- function(data.zip.file="UCI HAR Dataset.zip") {
    # load the training and testing datasets from the zip file and calculate the mean of each of
    # the mean and standard deviation features for activity performed by each subject.
    
    # load the data set from the zip file (may load a cached version of the data)
    df.all.data <- load.data(data.zip.file)
    
    # remove the activity.code field, we will use the activity.name instead
    df.all.data <- df.all.data[, !(names(df.all.data) %in% "activity.code")]
    
    # melt the data so that we can use tapply
    df.melted.data <- melt(df.all.data, id.vars=c("subject.id", "activity.name"))
    
    # calculate the average of each statistic for each activity and subject
    df.means <- aggregate(df.melted.data$value, 
                          list(df.melted.data$subject.id, 
                               df.melted.data$activity.name, 
                               df.melted.data$variable), 
                          mean)
    
    
    # rename the columns to something meaningful
    names(df.means) <- c("subject.id", "activity.name", "variable", "value")
    
    # unmelt the data, so that each subject/activity combination has a single row with all stats
    # in a dataframe with subject id, activity code and features for column names
    df.means <- dcast(df.means, subject.id + activity.name ~ variable)
    
    # return the final analysis
    df.means
}
