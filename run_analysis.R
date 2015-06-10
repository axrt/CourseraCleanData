#This script is supposed to be run with 
#source("run_analysis.R")
#It contains a sequence of function calls that merge the training and test datasets from cell phone data, renames and matches with the subjects
#in the study. In particular it accomplishes the follwing set of
#Tasks:
#1. Merge the training and the test sets to create one data set.
#2. Extract only the measurements on the mean and standard deviation for each measurement.
#3. Use descriptive activity names to name the activities in the data set.
#4. Appropriately labels the data set with descriptive variable names.
#5. From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.

######## Const ######## 
#Name/alias of the project
samsung<-"samsung"
#Common extentions
ext=".txt"

######## Libs ########
#dplyr for dataframe manipulation
library(dplyr)
#reshape2 for melt()
library(reshape2)
#ggplot2 for graphics output
library(ggplot2)

######## Create resource folder ########
#' Creates a resource folder in the current working directory.
#' 
#' @param \code{res.folder} folder name, default "res". 
#' @return a path to the resource (\code{y}) folder.
#' @examples \code{
#' create.res()
#' create.res("test")
#' } 
#' 
create.res <- function(res.folder="res"){
  #If the resource directory does not exist - create it
  if(!file.exists(res.folder)){
    dir.create(res.folder)
    message(paste("Resource folder \"",res.folder,"\" was created!",sep = "",collapse = ""))
  }#otherwise - create one
  else{
    message(paste("Resource folder is: \"",res.folder,"\"!",sep = "",collapse = ""))
  }
  return(res.folder)
}

#' Downloads and unzips the dataset from the study to a given resource folder. Cleans up the arcive and renames the folder to \code{samsung}.
#' Sends \code{data.folder} return to the global scope.
#' 
#' @param \code{res.folder} folder name, default "res". 
#' @param \code{file} url to the dataset archive, default "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip".
#' @return \code{data.folder} path to the data folder.
#' @examples \code{
#' download.res()
#' download.res("res")
#' download.res("res","https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip")
#' } 
#' 
######## Download data #######
download.res <-function(res.folder="res", file = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"){
  #If the data has not been downloaded yet - do so
  if (!file.exists(paste(res.folder,samsung, sep="/"))) {
    message("Downloading Samsung data...")
    arch.res<-paste(res.folder,samsung,sep="/")
    download.file(file, destfile=arch.res, method="curl")
    unzip(zipfile = arch.res, exdir=res.folder)
    #Cleanup
    file.remove(paste(res.folder,samsung,sep="/"))
    file.rename(from = paste(res.folder,"UCI HAR Dataset", sep="/"), to=paste(res.folder,"samsung", sep="/"))
  }
  #Make data.folder global constant
  data.folder<<-paste(res.folder,samsung,sep="/")
  return(data.folder)
}

#' Loads the data from the data folder (given in \code{data.folder} top scope variable) from a number of data tables.
#' Uses \code{ext} (given in \code{ext} variable)
#' 
#' @param \code{train} training data prefix, default "train".
#' @param \code{test} testing data prefix, default "test".
#' @param \code{x.pref} X data prefix, default "X_". 
#' @param \code{y.pref} y data prefix, default "y_". 
#' @param \code{subject} subject data prefix, default "subject_". 
#' @param \code{features} features data prefix, default "features". 
#' @return a list of data frames, each can be accessed by $
#' @examples \code{
#' load.data()
#' load.data("train")
#' load.data("train", "test")
#' } 
#' 
######## Task 1: Merge ######## 
load.data <- function(train="train",test="test",x.pref="X_",y.pref="y_", subject="subject_", features="features") {
  
  #Convinience function that loads the data from text files
  data.get<-function(what,which){
    res.file<-paste(data.folder,what,paste(which,what,ext,sep = ""),sep="/")
    message(paste("Loading",res.file,"..."))
    return(read.table(file = res.file, stringsAsFactors=FALSE))
  }
  
  #Load the data
  x.train<-data.get(train,x.pref)
  x.test<-data.get(test,x.pref)
  y.train<-data.get(train,y.pref)
  y.test<-data.get(test,y.pref)
  subject.train<-data.get(train,subject)
  subject.test<-data.get(test,subject)
  features.data<-read.table(file = paste(data.folder,paste(features,ext,sep = ""),sep = "/"),stringsAsFactors=FALSE)
  
  return(list(x.train=x.train,x.test=x.test,y.train=y.train,y.test=y.test, subject.train=subject.train, subject.test=subject.test, features.data=features.data))
}

#' Merges test and train data given the parameter
#' 
#' @param \code{list.of.frames} list of data frames from cell phone dataset, relyes on \link{load.data} function.
#' @return data frame with x,y,s,features data frames, where x,y and s are rowbibds from the training and test data.
#' @examples \code{
#' merge.data(load.data())
#' } 
#'
merge.data<-function(list.of.frames){
  #Merge rows
  merge.data<-list(x=bind_rows(list.of.frames$x.train,list.of.frames$x.test),
                    y=bind_rows(list.of.frames$y.train,list.of.frames$y.test),
                    s=bind_rows(list.of.frames$subject.train,list.of.frames$subject.test), 
                    features.data=list.of.frames$features.data)
  return(merge.data)
}

#' Gets all variables wihich contain mean values.
#' 
#' @param \code{merged.data} list of dataframes from \link{merge.data}.
#' @return a dataframe of mean values
#' @examples \code{
#' get.mean(merge.data(load.data()))
#' }
#' 
######## Task 2: Extract Mean, Std ######## 
get.mean<-function(merged.data){
  mean.data<-merged.data$features.data %>% filter(grepl(x = V2,pattern = "mean()",fixed = TRUE))
  mean.data.filtered<-merged.data$x[,mean.data$V1]
  colnames(mean.data.filtered)<-mean.data$V2
  message(paste("Found means:",ncol(mean.data.filtered)))
  return(mean.data.filtered)
}

#' Gets all variables wihich contain standard deviation values.
#' 
#' @param \code{merged.data} list of dataframes from \link{merge.data}.
#' @return a dataframe of std values
#' @examples \code{
#' get.std(merge.data(load.data()))
#' }
#' 
get.std<-function(merged.data){
  std.data<-merged.data$features.data %>% filter(grepl(x = V2,pattern = "std()",fixed = TRUE))
  std.data.filtered<-merged.data$x[,std.data$V1]
  colnames(std.data.filtered)<-std.data$V2
  message(paste("Found stds:",ncol(std.data.filtered)))
  return(std.data.filtered)
}

#' Reads the activity labels lookup table.
#' 
#' @param \code{activiy.labels} name of activity lables table, default "activity_labels".
#' @return activity labels lookup table
#' @examples \code{
#' read.activity.lookup()
#' read.activity.lookup("activity_labels")
#' }
######## Task 3,4: Descriptive Names ########
read.activity.lookup<-function(activity.labels="activity_labels"){
  return(read.table(file=paste(data.folder,paste(activity.labels,ext,sep = ""),sep = "/"), stringsAsFactors=FALSE))
}

#' Attaches labels/names from the activity lookup to the corresponding numeric label and renames y data to "Activity" and the s data to "Sample"
#' 
#' @param \code{merged.data} list of dataframes from \link{merge.data} funciton. 
#' @param \code{activity.lookup} lookup table from \link{read.activity.lookup} function. 
#' @examples {
#' attach.names(merge.data(load.data()),read.activity.lookup())
#' }
attach.names<-function(merged.data,activity.lookup){
  colnames(merged.data$y)<-"Activity"
  colnames(merged.data$s)<-"Sample"
  merged.data$y<-merged.data$y %>% mutate(Activity=sapply(Activity,function(i){return(activity.lookup[i,2])}))
  return(merged.data)
}

#' Script-like function, the runs the above commands in a proper sequence to clean and tidy-up the data.
#' 
#' @return \code{output.data} tidy data frame
#' @examples \code{
#' write.csv(x = coursera.clean.data.main(),file = "samsung.csv", row.names=FALSE)
#' }
#' 
######## Task 5: Clean the Data ########
coursera.clean.data.main<-function(){
  #0.download the data
  message(paste("Preparing resources in ", download.res(res.folder = create.res())))
  message("Merging data...")
  #1.load the data
  data<-load.data()
  #2.merge the test and train data
  merged.data <- merge.data(data)
  #3.get mean values
  mean.data<-get.mean(merged.data)
  #4.get standard deviation data
  sd.data<-get.std(merged.data)
  #5.load the lookup table
  activity.lookup<-read.activity.lookup()
  #6.sign human-readable labels
  merged.data<-attach.names(merged.data,activity.lookup)
  #7.create a new list to sent to column binding funciton all at once
  output.data<-list(mean.data=mean.data, sd.data=sd.data, activity=merged.data$y, s=merged.data$s)
  #8.bind all columns in a single dataframe
  output.data<-bind_cols(output.data)
  #9.group the data by Sample and Activity and summarize all values as a mean per group
  output.data<-output.data %>% group_by(Sample,Activity) %>% summarise_each(funs(mean))   
 
  return(output.data)
}

######## Write out the data ########
#Wirte out the tidy data
tidy.data<-coursera.clean.data.main()
write.table(x = tidy.data,file = "samsung.csv", row.names=FALSE)
message("Tidy data written to samsung.csv :)")

#' Plots the tidy data to a pdf (plot.pdf).
#' 
#' @param \code{tidy.data} tidy data
#' @param \code{file} file to save the plot, default "plot.pdf" in the working directory
#' @param \code{width} width of the plot, default 100
#' @param \code{height} height of the plot, default 100
#' @example \code{
#' plot.tidy(coursera.clean.data.main())
#' }
#' 
######## Plot the data ########
plot.tidy<-function(tidy.data, file="plot.pdf", width = 100, height = 100){
  tidy.melt<-melt(tidy.data, id.vars=c("Sample","Activity"))
  gp<-ggplot(data=tidy.melt, aes(x=variable, y=value, fill=variable)) + 
    geom_bar(stat="identity")+facet_wrap(~Sample+Activity, nrow=30) + 
    theme(axis.text.x = element_text(size=20,angle = 90,colour = "grey25"),
          axis.text.y = element_text(size=14,angle = 90,colour = "grey25"),
          strip.text = element_text(size = 30),
          plot.background = element_rect(fill="white", colour = "white"),
          strip.background = element_rect(fill="grey95", colour = "grey95"),
          panel.background = element_rect(fill = "white", colour = NA), 
          panel.border = element_blank(), 
          panel.grid.major = element_line(colour = "grey95"), 
          panel.grid.minor = element_line(colour = "grey95", size = 0.25), 
          panel.margin.x = NULL, 
          panel.margin.y = NULL,
          legend.position= "none",
          axis.ticks = element_line(colour = "grey95"))
  pdf()
  plot(gp)
  dev.off()
}

