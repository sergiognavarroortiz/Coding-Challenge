###########################################
# Preparing a dataset for Machine Learning#
###########################################

#The effectiveness of Machine Learning depends in a large extent to the data. The preparation of the data is very
#important, like the design of algorithms.

#The preparation of the data has different stages that explain in the following lines of text:

#1. First, it is important loading the data and review its original structure. I achieve this, if data is reviewed row by
#row only in the case that is a small dataset.

#For larger datasets, I can achieve this, using commands

#Then, I will continue with Data Cleaning, this is with the intention to find Data that contains values that cannot be
#used (NA, NaN, etc.)

# Example #

# Data creation
id <- c(1,4,3,NA,7,6,9,4,0,8)
text <- c("a", "b", NA, "NA","a","b","b","b","c","d")
number <- c(2,8,7,5,1,9,4,3,7,2)
data <- data.frame(id=id,text=text,number=number)

View(data)   #Visualizing all data

str(data)   #Data Structure

head(data, n=10)  #First 10 rows of data

tail(data)  #Last rows of data

sapply(data, function(x) sum(is.na(x)))  #Counts NA values

#Deleting NA values

# Option 1 #
#Eliminate rows with NA values
data <- data[!is.na(data$id),]
data <- data[!is.na(data$text),]
View(data)

# Option 2 #
#Eliminate all rows with NA values
delete.na <- function(df, n=0) {
  df[rowSums(is.na(df)) <= n,]
}

delete.na(data)

# Option 3 #
#Eliminate all rowa with NA values (Simplified)
datos <- na.omit(data) 


#Note: this a simple example of how to clean data, in case this data contains values which cannot be used. Not always
#eliminating data is the most recommended, in some cases the missing values could be calculated with interpolations,
#for example.

#2. Secondly, now we should determine if all variables are useful or only some of them are useful

# Example #

# Data creation
id2<-seq(1:3)
image<- c("img1","img2","img3")
sex<-c("M","F","M")
os<-c("ios","ios","ios")
data2<-data.frame(id2=id2,image=image,sex=sex,os=os)
data2$image<-as.character(data2$image)

str(data2)  #Data estructure

#Note: for this particular case, "id" is an integer, variables "sex" and "os" are factors, and image was forced
#to be detected as character, this with the intention the following process would be illustrative.

#From the created data, I observed, most of it wasn´t in an adequate format, besides, the variable "id" is not useful
#to obtain the prediction, since it is only the identification of customers.

#Eliminate "id"
library(dplyr)
data2 <- select(data2, -id2)

#Conversion to the correct class
data2$image<-as.factor(data2$image)
data2$sex<-as.factor(data2$sex)
data2$os<-as.factor(data2$os)

str(data2) #Data structure


#3. The third stage is Exploratory Analysis and Inferential Statistics

#This process was described in the document Coding Challenge. Anyway, I will make a brief description.

#The intention is to determine the relationships between the different variables of Prediction, so it can be determined
#if there exist enough relationships so I can construct models of Prediction, also this procedure helps me to 
#explore data very deeply.


#4. The fourth stage is preparing data for training of Prediction Model.

#In this stage, the normalization of data will be executed, also combining of predictor and additional preparation of
#variables, so it can be used, this way the Model of Prediction will clearly understand the relationships with the
#variable of prediction

#The case of Normalization, it is clearly explained in the document called "NORMALIZATION" also included in this github
#repository









