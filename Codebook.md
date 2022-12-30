Libraries needed:
- dplyr
- stringr

All data is available in folder: 'UCI_HAR_Dataset'

Raw data:

        X_train, y_train, subject_train
        X_test, y_test, subject_test

The raw data is first combined in three datadrames (with rbind):

        X_df <- rbind(X_train, X_test)
        y_df <- rbind(y_train, y_test)
        subject_df <- rbind(subject_train, subject_test)
        
Columns names are from file: 'features.txt'
Activities names are from file: 'activity_labels.txt'

The features with mean or standard deviation are selected using str_which:

        mean_std_feature_index <- str_which(feature_names$V2, 'mean|std')
        X_df <- select(X_df, all_of(mean_std_feature_index))

Columns in X_df are renamed using names from 'feature_names.txt':

        names(X_df) <- feature_names$V2[mean_std_feature_index]
        
Merge is used to have a column with activity name:

        y_df <- left_join(y_df, activity_names)
        names(y_df) <- c('activity_num', 'activity_name')

The three dataframes are merged using cbind:

        tidy_df <- cbind(subject_df, y_df, X_df)

The second dataframe is created grouping by activity and subject, then summarised by the mean (columns names are modified with the prefix : 'mean_of_'):

        tidy_df_grouped <- tidy_df
        tidy_df_grouped <- tidy_df_grouped[-2]
        tidy_df_grouped <- tidy_df_grouped %>% group_by(activity_name, subject) %>% summarise(across(everything(), mean))
        colnames(tidy_df_grouped)[-c(1,2)] <- paste0('mean_of_', colnames(tidy_df_grouped)[-c(1,2)])
        

Feature Selection 
=================

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

tBodyAcc-XYZ
tGravityAcc-XYZ
tBodyAccJerk-XYZ
tBodyGyro-XYZ
tBodyGyroJerk-XYZ
tBodyAccMag
tGravityAccMag
tBodyAccJerkMag
tBodyGyroMag
tBodyGyroJerkMag
fBodyAcc-XYZ
fBodyAccJerk-XYZ
fBodyGyro-XYZ
fBodyAccMag
fBodyAccJerkMag
fBodyGyroMag
fBodyGyroJerkMag

The set of variables that were estimated from these signals are: 

mean(): Mean value
std(): Standard deviation
mad(): Median absolute deviation 
max(): Largest value in array
min(): Smallest value in array
sma(): Signal magnitude area
energy(): Energy measure. Sum of the squares divided by the number of values. 
iqr(): Interquartile range 
entropy(): Signal entropy
arCoeff(): Autorregresion coefficients with Burg order equal to 4
correlation(): correlation coefficient between two signals
maxInds(): index of the frequency component with largest magnitude
meanFreq(): Weighted average of the frequency components to obtain a mean frequency
skewness(): skewness of the frequency domain signal 
kurtosis(): kurtosis of the frequency domain signal 
bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.
angle(): Angle between to vectors.

Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:

gravityMean
tBodyAccMean
tBodyAccJerkMean
tBodyGyroMean
tBodyGyroJerkMean

The complete list of variables of each feature vector is available in 'features.txt'