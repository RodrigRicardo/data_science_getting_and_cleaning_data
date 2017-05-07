# Project R

# Read data into tables

X_test<-read.table("UCI_HAR_Dataset/test/X_test.txt") #  Read tables into R
X_train<-read.table("UCI_HAR_Dataset/train/X_train.txt")

# Merge the data sets

XY_data<-rbind(X_test,X_train)  #  merge the two sets (by rows)

#  Assign a meaningful label to each column

names_data<-read.table("UCI_HAR_Dataset/features.txt")
colnames(XY_data)<-names_data[,2]  # assign names to columns 

# Assign meaningful labels to each row for the activities vector

y_test<-read.table("UCI_HAR_Dataset/test/y_test.txt")
y_train<-read.table("UCI_HAR_Dataset/train/y_train.txt")
xy_tt<-rbind(y_test,y_train)
activities<-xy_tt$V1

# activities is a numeric vector, transforming it into "meaningful" values

activities<-replace(activities,activities==5,"Standing")
activities<-replace(activities,activities==1,"Walking")
activities<-replace(activities,activities==2,"Walking upstairs")
activities<-replace(activities,activities==3,"Walking downstairs")
activities<-replace(activities,activities==4,"Sitting")
activities<-replace(activities,activities==6,"Laying")

# Extract the measurements of the mean and standard deviation

mean_data<-grep("mean",names_data$V2) # obtain index of columns with names containing "mean"
std_data<-grep("std",names_data$V2)
mean_XY_data<-XY_data[,mean_data] # subset by the indeces 
std_XY_data<-XY_data[,std_data]

# Obtain information about the subject making the experiment

subject_test<-read.table("UCI_HAR_Dataset/test/subject_test.txt")
subject_train<-read.table("UCI_HAR_Dataset/train/subject_train.txt")

subjects<-rbind(subject_test,subject_train) # bind by row
tidy_1<-cbind(subjects,activities,mean_XY_data,std_XY_data) # bind by column the right data frames
colnames(tidy_1)[1] <- "subjects"  # correct the first name

# now we need to calculate the mean of each variable using the activity and subject

library(dplyr)

tidy_1$activities<- as.character(tidy_1$activities) # change factor variables to character
tidy<-tidy_1 %>% group_by(activities,subjects) %>% summarise_each(funs(mean))
write.table(tidy,"tidy_1.txt",row.names = FALSE, col.names = F)
names_tidy<-colnames(tidy)
write.table(names_tidy,"code_book.txt",col.names = F )
