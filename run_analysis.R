#run_analysis.R
# the main script to perform the analysis from Human Activity Recognition 
#Using Smartphones Dataset.
#The analysis generates a tidy dataset  from the original training and test datasets

#Read the featuring label
setwd("cleaningdata")
featlabel <- read.csv("UCIHARDataset//features.txt", sep=" ",header=FALSE)
names(featlabel) <- c("featid","flabel")


#Step 1 merge the training e test dataset
#read training dataset only with measurement of mean and standard deviation
trainingds <- read.table("UCIHARDataset//train//X_train.txt", header=FALSE)
colnames(trainingds)<-featlabel$flabel
#read training subject
trainingsub <- read.csv("UCIHARDataset//train//subject_train.txt", header=FALSE)
colnames(trainingsub) <- c("subject_id")
#read training y activity
trainingact <- read.csv("UCIHARDataset//train//y_train.txt", header=FALSE)
colnames(trainingact) <- c("act_id")
#merge the training input
traindataset <- cbind(trainingds,trainingsub,trainingact)
#read test dataset
testds <- read.table("UCIHARDataset//test//X_test.txt", header=FALSE)
colnames(testds)<-featlabel$flabel
#read tet subject
testsub <- read.csv("UCIHARDataset//test//subject_test.txt", header=FALSE)
colnames(testsub) <- c("subject_id")
#read test y activity
testact <- read.csv("UCIHARDataset//test//y_test.txt", header=FALSE)
colnames(testact) <- c("act_id")
#merge the test input
testdataset <- cbind(testds,testsub,testact)

#generate the mergeddataset 
mergedataset <- rbind(traindataset,testdataset)

#2 - Extracts only the measurements on the mean and standard deviation for each measurement. 
#subset features the contains mean and std in its names.
featlabelm <- featlabel[grep("mean",featlabel$flabel),]
featlabels <-  featlabel[grep("std",featlabel$flabel),]
featlabelms <- rbind(featlabelm,featlabels)
#select the column in mergedataset by column index inside featlabelms
mergemeands <- mergedataset[,c(featlabelms$featid,562,563)]

# 3 Uses descriptive activity names to name the activities in the data set
# read file activity_labels
actlabels <- read.table("UCIHARDataset//activity_labels.txt", header=FALSE)
names(actlabels) <- c("act_id","act_label")
#merge activity_labels.txt with mergemeands on act_id labels -> generate mergemeandslb
mergemeandslb <- merge(mergemeands, actlabels,by="act_id" )

#4Appropriately labels the data set with descriptive variable names.
#This point is already resolved in step 1 cause it associates column names to original datasets
outdataset <- aggregate(mergemeandslb[,2:80], by=list(Act_id=mergemeandslb$act_id,Act_label=mergemeandslb$act_label,Subject_id=mergemeandslb$subject_id), FUN=mean)
write.table(outdataset, 'outputdataset.txt', row.name=FALSE)
