#Tasks:
#1. Merge the training and the test sets to create one data set
#2. Extract only the measurements on the mean and standard deviation for each measurement
#3. Use descriptive activity names to name the activities in the data set
#4. Appropriately labels the data set with descriptive variable names 
#5. From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject

######## Const ######## 
samsung<-"samsung"

######## Libs ########
library(dplyr)
library(reshape2)

######## Create resource folder ######## 
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

######## Task 1: Merge ######## 
load.data <- function(train="train",test="test",x.pref="X_",y.pref="y_", ext=".txt") {
  
  data.get<-function(what,which){
    res.file<-paste(data.folder,what,paste(which,what,ext,sep = ""),sep="/")
    message(paste("Loading",res.file,"..."))
    return(read.table(file = res.file))
  }
  
  #Load the data
  x.train<-data.get(train,x.pref)
  x.test<-data.get(test,x.pref)
  y.train<-data.get(train,y.pref)
  y.test<-data.get(test,y.pref)
  
  return(list("x.train"=x.train,"x.test"=x.test,"y.train"=y.train,"y.test"=y.test))
}

merge.data<-function(){
  
}

coursera.clean.data.main<-function(){
  message(paste("Preparing resources in ", download.res(res.folder = create.res())))
  message("Merging data...")
  merge.data <- merge.data()
}

