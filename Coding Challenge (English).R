##########################
# Solution for Problem 1 #
##########################

#Load Data
library(readxl)
data <- read_excel("Here is the location of the file.xlsx")
View(data)

##########################################################
# We start with an exploratory analysis of the variables #
##########################################################

#Checking data and name of variables
str(data)
names(data)

#Name of the variables
var<-names(data)
var

#Keep checking types of variables
class(data$LineItemID)
class(data$ContentUrl)
class(data$CampaignID)
class(data$StoryID)
class(data$Channel)
class(data$Preview_Headline)
class(data$Preview_Image)
class(data$Channel_Ad_ID)
class(data$Gender_Targeting)
class(data$Age_Targeting)
class(data$Device_Targeting)
class(data$Geo_Targeting)
class(data$Interest_Targeting)
class(data$Language_Targeting)
class(data$OS_Targeting)
class(data$Lifetime_Spend)
class(data$Lifetime_Clicks)
class(data$Lifetime_Engagements)
class(data$CPE)

#Conversion to the correct class of variables (in case R didn´t do it)
data$LineItemID<-as.factor(data$LineItemID)
data$ContentUrl<-as.factor(data$ContentUrl)
data$CampaignID<-as.factor(data$CampaignID)
data$StoryID<-as.factor(data$StoryID)
data$Channel<-as.factor(data$Channel)
data$Preview_Headline<-as.factor(data$Preview_Headline)
data$Preview_Image<-as.factor(data$Preview_Image)
data$Channel_Ad_ID<-as.factor(data$Channel_Ad_ID)
data$Gender_Targeting<-as.factor(data$Gender_Targeting)
data$Age_Targeting<-as.factor(data$Age_Targeting)  #Pre-treated for a better reading of R
data$Device_Targeting<-as.factor(data$Device_Targeting)
data$Geo_Targeting<-as.factor(data$Geo_Targeting)
data$Interest_Targeting<-as.factor(data$Interest_Targeting)
data$Language_Targeting<-as.factor(data$Language_Targeting)
data$OS_Targeting<-as.factor(data$OS_Targeting)
data$Lifetime_Spend<-as.numeric(data$Lifetime_Spend)  #Pretreated to eliminate $ values
data$Lifetime_Clicks<-as.numeric(data$Lifetime_Clicks)
data$Lifetime_Engagements<-as.numeric(data$Lifetime_Engagements)
data$CPE<-as.numeric(data$CPE)  #Pretreated to eliminate $ values

#I suspect that variables Preview_Image, Geo_Targeting, Language_Targeting, OS_Targeting,Lifetime_Clicks y Lifetime_Engagements
#only contain a value, if it is correct those columns will be eliminated, since
#this value won´t help me for prediction of those variables "Available metrics at lineitem level"

#Determining if variables Preview_Image, Geo_Targeting, Language_Targeting, OS_Targeting, Lifetime_Clicks y 
#Lifetime_Engagements contain only one value
factor(data$Preview_Image)
factor(data$Geo_Targeting)
factor(data$Language_Targeting)
factor(data$OS_Targeting)
range(data$Lifetime_Clicks)
range(data$Lifetime_Engagements)

#For this example we will  consider variables Preview_Image, Geo_Targeting, Language_Targeting and
#OS_Targetin contain only one value, therefore, they are not good for prediction, while variables
#variavles Lifetime_Engagements y Lifetime_Clicks have a range of values, since
#they belong for the same country, with same language y and the same mobile operating system 
#while last 2 variables are good for prediction, therefore, I think that these variables should have 
#different numeric values.

#Erasing variables that aren´t good for prediction
library(dplyr)
data <- select(data, -Preview_Image, -Geo_Targeting, -Language_Targeting, -OS_Targeting)

#Correlations analysis
library(psych)
pairs.panels(data,cex=16)

#With this procedure, we could observe if there are relations between variables. 

#Supposing that variables CampaignID, Age_Targeting y Device_Targeting would have relation, I could
#make a more advanced study to prove it. This will be showed next:

#Description of each one of categorical variables
attach(data)
table(CampaignID)
table(Age_Targeting)
table(Device_Targeting)

#Relation between Age_Targetin con CampaignID y Device_Targeting with plot
table_Age_CID<-table(Age_Targeting,CampaignID)
plot(table_Age_CID,col=c("red","blue"),main="Age vs CampaignID")

table_Age_Device<-table(Age_Targeting,Device_Targeting)
plot(table_Age_Device,col=c("red","blue"),main="Age vs Device")

detach(data)

#Test square-chi for both relations
chisq.test(table_Age_CID)    
chisq.test(table_Age_Device)

#Next we will be able to determine the correlation degree of variables, in order to
#determine if variables will be good for prediction of unknown metrics.

##########################################################################
# Deep Neural Networks (deep learning) for prediction of unknown metrics #
##########################################################################

#The process shown here must be done including all prediction variables (Metrics unknown),
#The first variable to predict must be the one which more correlation, compared with rest of known 
#variables, with the purpose that the variable with less correlation we could add other variables mas
#for its prediction, in order to make it more precise.

#For illustrative purposes I will make prediction of CPE, but I will start with varible with mor
#correlation with the rest of known variables and continuing for the following, leaving CPE at the  
#final, since CPE id the variable of more importance. 

#I will watch the distribution of the variable for prediction
hist(data$CPE ,col = "red",xlab = "Histograma de CPE")

#Conversion of attributes to factors
require(nnet)
LineItemID<-class.ind(data$LineItemID)   #Extract the attribute of dataset and create a matrix of each categorical variable
colnames(LineItemID)=c("lid1","lid2","lid3",.......,"lid30000000")   #Adding to a numeric value a label what it means their factor value
head(LineItemID)

ContentUrl<-class.ind(data$ContentUrl)   
colnames(ContentUrl)=c("url1",.......,"url543040")  
head(ContentUrl)

CampaignID<-class.ind(data$CampaignID)   
colnames(CampaignID)=c("cid1",.......,"cid100")  
head(CampaignID)

StoryID<-class.ind(data$StoryID)   
colnames(StoryID)=c("sid1_1",.......,"sid100_1")  
head(StoryID)

Channel<-class.ind(data$Channel)   
colnames(Channel)=c("fb",.......,"yh")  
head(Channel)

Preview_Headline<-class.ind(data$Preview_Headline)   
colnames(Preview_Headline)=c("hl1",.......,"hl2")  
head(Preview_Headline)


Channel_Ad_ID<-class.ind(data$Channel_Ad_ID)   
colnames(Channel_Ad_ID)=c("adfb1","adfb2","adyh1",.......,"adyh154")  
head(Channel_Ad_ID)

Gender_Targeting<-class.ind(data$Gender_Targeting)   
colnames(Gender_Targeting)=c("M","F")  
head(Gender_Targeting)

Age_Targeting<-class.ind(data$Age_Targeting)   
colnames(Age_Targeting)=c("35a44",.......,"55a64")  
head(Age_Targeting)

Device_Targeting<-class.ind(data$Device_Targeting)   
colnames(Device_Targeting)=c("D",.......,"M")  
head(Device_Targeting)

Interest_Targeting<-class.ind(data$Interest_Targeting)   
colnames(Interest_Targeting)=c("intid_fb1","intid_yh1",.......,"intid_yh30")  
head(Interest_Targeting)

#Create R Objects separated for the rest of attributes
Lifetime_Spend<-as.data.frame(dataset$Lifetime_Spend)
colnames(Lifetime_Spend)=c("Lifetime_Spend")

Lifetime_Clicks<-as.data.frame(dataset$Lifetime_Clicks)
colnames(Lifetime_Clicks)=c("Lifetime_Clicks")

Lifetime_Engagements<-as.data.frame(dataset$Lifetime_Engagements)
colnames(Lifetime_Engagements)=c("Lifetime_Engagements")

#All R objects in a data frame
sample<-cbind(LineItemID,ContentUrl,CampaignID,StoryID,Channel,Preview_Headline,Channel_Ad_ID,Gender_Targeting,Gender_Targeting,Age_Targeting,Device_Targeting,Interest_Targeting,Lifetime_Spend,Lifetime_Clicks,Lifetime_Engagements)

#Normalizing attributes
sample<-scale(sample)

#Separate variable of prediction
target<-as.matrix(data$CPE)
colnames(target)=c("target")

#Combine training variables with prediction variable
data<-cbind(sample,target) 
data<-as.data.frame(data)

#Preparing train set
rand_seed=2018
set.seed(rand_seed)
train<-sample(1:nrow(data),"number of adequate data for training",FALSE)

#Function to adhere all the variables and make the adjustment
formu<-function(y_label,x_labels){
  as.formula(sprintf("%s~%s",y_label,
                     paste(x_labels,collapse = "+")))
}

#Almacenated formula in f de a~b+c+d+e+f...
f<-formu("target",colnames(data[,-15]))
f

#Creating from a first simple model with 2 hidden layers, where first only has a neuron
#The second has 2 neurons

#Creating first simple model
require(neuralnet)
set.seed(rand_seed)
fitn<-neuralnet(f,
                data = data[train,],
                hidden = "Neuronas por capa",
                algorithm = "rprop+",     #algorithm could be rprop-,sag,slr. Where rprop+ y rprop- # refer to resilence backpropagation with and without weight backtracking; and sag refers to the # smallest absolute derivate, asnd slr(smallest learning rate) refer to the modified globally converget # algorithm often called grprop
                err.fct="sse",         #Error function could be selected between: sum of squared errors # and cross-entropy "ce"
                act.fct = "logistic",    #Activacion could be: logistic (sigmoid) or tanh 
                threshold = 0.01,
                rep="number of repetitions of algoritmo",
                linear.output = TRUE)      #linear.output=TRUE is for regression problems y FALSE para # problemas de clasificacion

#To measure the performance of model, it will be used MSE and R-squared for a perfect fit the MSE will #equal zero and R-Squared equal 1. 

#Punctuation measurement
scoresn<-compute(fitn,data[train,1:14])
pred1<-scoresn$net.result

y_train=data[train,15]
require(Metrics)

round(mse(pred1,y_train),4)

round(cor(pred1,y_train)^2,4)

#This process would be adjusted, according to result, until obtain the model with better result
#Finally, when determining the model with more probability it is tested with test data

#Prediction of adjustment models
y_test=data[-train,15]
scores_testn<-compute(fitn,data[-train,1:32])
pred_testn=scores_testn$net.result

round(mse(pred_testn,y_test),4)

round(cor(pred_testn,y_test),4)

#If model proves to accomplish a precise prediction, then, it will be accepted and continue
#next model of prediction, for second variable and so this way, until obtaining variable
#of prediction CPE. The Predicted variable will be added to known variables to improve prediction 
#of unknown variables. 

######################
# Problem 2 Solution #
######################

#The methods of optimization to solve this Coding Challenge
#Since we don´t have real data. I will use Genetic Algorithm with Linear Regression to show you 

#Categorical Variables Conversion to numeric
data$LineItemID<-as.numeric(data$LineItemID)
data$ContentUrl<-as.numeric(data$ContentUrl)
data$CampaignID<-as.numeric(data$CampaignID)
data$StoryID<-as.numeric(data$StoryID)
data$Channel<-as.numeric(data$Channel)
data$Preview_Headline<-as.numeric(data$Preview_Headline)
data$Channel_Ad_ID<-as.numeric(data$Channel_Ad_ID)
data$Gender_Targeting<-as.numeric(data$Gender_Targeting)
data$Age_Targeting<-as.numeric(data$Age_Targeting)
data$Device_Targeting<-as.numeric(data$Device_Targeting)
data$Interest_Targeting<-as.numeric(data$Interest_Targeting)

#Adjust Function for our Genetic Algorithm 
CPE<-function(data,b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,b10,b11,b12,b13,b14){
  attach(data,warn.conflicts = F)
  Y_hat<-b0+b1*LineItemID+b2*ContentUrl+b3*CampaignID+b4*StoryID+b5*Channel+b6*Preview_Headline+b7*Channel_Ad_ID+b8*Gender_Targeting+b9*Age_Targeting+b10*Device_Targeting+b11*Interest_Targeting+b12*Lifetime_Spend+b13*Lifetime_Clicks+b14*Lifetime_Engagements
  SSE=t(CPE-Y_hat) %*% (CPE-Y_hat)
  detach(data)
  return(SSE)
}

#Genetic Algorithm
library(genalg)
ga.CPE<-ga(type='real-valued',min(1,1,1,1,1,1,1,1,1,1,1,45,1000,500,0.09),   #The values are assumptions, taken from the data with which we have as an example
           max=c(n,n,n,n,n,n,n,n,n,n,n,n,n,n,n),popSize=n,maxiter=n,
           names=c('intercept','LineItemID','ContentUrl','CampaignID','StoryID','Channel','Preview_Headline',
                   'Channel_Ad_ID','Gender_Targeting','Age_Targeting','Device_Targeting','Interest_Targeting',
                   'Lifetime_Spend','Lifetime_Clicks','Lifetime_Engagements'),
           keepBest=T,fitness=function(b)-CPE(data,b[1],b[2],b[3],b[4],b[5],b[6],b[7],b[8],b[9],b[10],b[11],b[12],b[13],b[14],b[15]))

#Plot of Algorithm
plot(ga.CPE)

#Summary
summary(ga.CPE)

#Finally, we obtained de ideal adjust of the variable
#For this example I used a Linear Model as Target Function
#But please note that for each situation it is needed 
#to choose the right function , based on the given data

