#Getting and Cleaning Data
##by Jeff Leek, PhD, Roger D. Peng, PhD, Brian Caffo, PhD

This repository contains `run_analysis.R` code file that carries out the cell phone data processing.
You may find the [description](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) and the [original data](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) by following the links.

---

### `run_analysis.R` ###
The code is documented and consists of a number of functions that perform the data processing. See the source code for details.

---

### Processing Script ###
The `run_analysis.R` perfroms the following tasks:

1. Checks if the resource folder exists and creates the folder if not
2. Checks if the data has been downloaded and downloads the [original data](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)
  from [UCI Machine Learning Repository](http://archive.ics.uci.edu/ml/index.html) if not, performs cleanup
3. Loads the data from data files
4. Merges the training and test sets
5. Extracts mean and standard deviation values for each measurement
6. Signs the human-readable labels to activity codings
7. Creates a second, independent tidy data set with the average of each variable for each activity and each subject
8. Saves the dity dataset to a .csv file

---

### Cleaning Cell Phone Sensor Data ###

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. [[source](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)]

Data captured (accelerometer and gyroscope):

1. 3-axial linear acceleration
2. 3-axial angular velocity at a constant rate of 50Hz 

The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. [[source](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)]

The merged dataset from **4** results in 10299 measurements.  **5** extracts 33 mean and 33 standard deviation values per each measurement.
There are six types of measurements (see above), which get assigned to the measurements. Variable names get attached to make the dataset more understandable.
The resulting tidy dataset has 180 rows and 68 rows, each row contains mean values per subject per each variable.
Finally, the tidy dataset is saved to samsung.csv (by default).

It is also possible to plot the data with `plot.tidy(tidy.data)` function, which will save a barplot to "plot.pdf" (or any other name given in `file` parameter). See [below](https://github.com/axrt/CourseraCleanData/raw/master/plot.pdf).

