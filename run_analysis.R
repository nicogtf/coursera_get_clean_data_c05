# libraries
library(dplyr)
library(stringr)


# read raw data
X_train <-  read.table('./UCI_HAR_Dataset/train/X_train.txt')
y_train <-  read.table('./UCI_HAR_Dataset/train/y_train.txt')

X_test <-  read.table('./UCI_HAR_Dataset/test/X_test.txt')
y_test <-  read.table('./UCI_HAR_Dataset/test/y_test.txt')

subject_train <-  read.table('./UCI_HAR_Dataset/train/subject_train.txt')
subject_test <-  read.table('./UCI_HAR_Dataset/test/subject_test.txt')

# combine features,labels and subjects train/test dataframes
X_df <- rbind(X_train, X_test)
y_df <- rbind(y_train, y_test)
subject_df <- rbind(subject_train, subject_test)

# columns names
feature_names <- read.table('./UCI_HAR_Dataset/features.txt')
feature_names <- select(feature_names, 2)

# activities names
activity_names <- read.table('./UCI_HAR_Dataset/activity_labels.txt')
activity_names$V2 <- tolower(activity_names$V2)

# find features that are mean or standard deviation
mean_std_feature_index <- str_which(feature_names$V2, 'mean|std')

# select only columns in X_df with mean/std
X_df <- select(X_df, all_of(mean_std_feature_index))

# rename columns in X_df
names(X_df) <- feature_names$V2[mean_std_feature_index]
names(subject_df) <- 'subject'

# create column with activity name and rename columns in y_df
y_df <- left_join(y_df, activity_names)
names(y_df) <- c('activity_num', 'activity_name')

# combine the three dataframes (column wise)
tidy_df <- cbind(subject_df, y_df, X_df)

# delete unused dataframes
rm(X_train, X_test, y_train, y_test, subject_train, subject_test, X_df, y_df, subject_df)
rm(activity_names, feature_names, mean_std_feature_index)

# second tidy dataframe (group by)
tidy_df_grouped <- tidy_df
tidy_df_grouped <- tidy_df_grouped[-2]
tidy_df_grouped <- tidy_df_grouped %>% group_by(activity_name, subject) %>% summarise(across(everything(), mean))
colnames(tidy_df_grouped)[-c(1,2)] <- paste0('mean_of_', colnames(tidy_df_grouped)[-c(1,2)])