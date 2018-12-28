##############################
# Product Demand Forecasting #
##############################

#Note: Before starting to run the code, it is necessary to replace "file location" with the location
#where the data is required to be downloaded.


#Loading data
urlloc="http://archive.ics.uci.edu/ml/machine-learning-databases/00275/Bike-Sharing-Dataset.zip"
download.file(urlloc,destfile = "C:/Users/"file location"/BikeSharingDataset.zip",method = "libcurl")

#Decompressing data
unzip("C:/Users/"file location"/BikeSharingDataset.zip")
dataset<-read.table("C:/Users/"file location"/day.csv",sep=",",skip = 0,header = T)

#Checking data
str(dataset)

#Separating climatic variables for analysis
dataset_clim<-dataset[,-c(1:8,13:16)]
dataset_clim<-as.data.frame(dataset_clim)

#Correlation plot of climatic variables 
require(corrplot)
correlacion<-cor(dataset_clim)
corrplot(correlacion, method = "circle",order="hclust",type=c("lower"))   #Correlations plot

#Histogram plot (Variable of prediction)
hist(dataset$registered,col = "red",xlab = "Count of registered users")

#To observe how is the distribution of data in Predictor
#Remove attributes that won´t be used for prediction
dataset$instant<-NULL
dataset$casual<-NULL
dataset$cnt<-NULL
dataset$yr<-NULL

#Conversion of attributes to factors
require(nnet)
season<-class.ind(dataset$season) #Extracts the attribute of dataset and create a matrix of each # categorical variable
colnames(season)=c("spring","summer","winter","fall") #Adds a label to a numeric value of the meaning of its factor
head(season)

month<-class.ind(dataset$mnth)
colnames(month)=c("jan","feb","mar","april","may","jun","jul","aug","sep","oct","nov","dec")

weekday<-class.ind(dataset$weekday)
colnames(weekday)=c("sun","mon","tue","wed","thu","fri","sat")

weather<-class.ind(dataset$weather)
colnames(weather)=c("clear","mist","light")

#Creates R objects separaated from the rest of attributes
holiday<-as.data.frame(dataset$holiday)
colnames(holiday)=c("holiday")

workingday<-as.data.frame(dataset$workingday)
colnames(workingday)=c("workingday")

temp<-as.data.frame(dataset$temp)
colnames(temp)=c("temp")

atemp<-as.data.frame(dataset$atemp)
colnames(atemp)=c("atemp")

hum<-as.data.frame(dataset$hum)
colnames(hum)=c("hum")

windspeed<-as.data.frame(dataset$windspeed)
colnames(windspeed)=c("windspeed")

#Joins all R objects in only one dataframe
sample<-cbind(season,month,holiday,weekday,workingday,weather,temp,atemp,hum,windspeed)

#Normalizing attributes
sample<-scale(sample)

#Combines the training variables with the Predictor
target<-as.matrix(dataset$registered)
colnames(target)=c("target")

data<-cbind(sample,log(target)) #executes algorithm of variable for a better adjustment
data<-as.data.frame(data)

#Preparing train set
rand_seed=2016
set.seed(rand_seed)
train<-sample(1:nrow(data),700,FALSE)

#Function to adhere all the variables to get the adjustment
formu<-function(y_label,x_labels){
  as.formula(sprintf("%s~%s",y_label,
                     paste(x_labels,collapse = "+")))
}

#Formula stored in f de a~b+c+d+e+f...
f<-formu("target",colnames(data[,-33]))
f

#Creates a first simple model simple with 2 hidden layers, the first one only has a neuron
#The second has 2 neurons

#Creates the first simple model
require(neuralnet)
set.seed(rand_seed)
fit1<-neuralnet(f,
                data = data[train,],
                hidden = c(1,3),
                algorithm = "rprop+",     #algorithm could be also rprop-,sag,slr. Where rprop+ y rprop- refer to resilence backpropagation with and without weight backtracking; and sag refers to the smallest absolute derivate, and slr(smallest learning rate) refer to the modified globally convergent algorithm often called grprop
                err.fct="sse",         #Error function can select between: sum of squared errors and #cross-entropy "ce"
                act.fct = "logistic",    #Activation function can be: logistic (sigmoid) o tanh 
                threshold = 0.01,
                rep=1,
                linear.output = TRUE)      #linear.output=TRUE is for regression problems de regresion #and FALSE for clasification problems

#To measure performance of model I use MSE and R-squared for a perfect fit the MSE will equal zero and
#R-Squared equal 1. 

#Measure punctuation
scores1<-compute(fit1,data[train,1:32])
pred1<-scores1$net.result

y_train=data[train,33]
require(Metrics)

round(mse(pred1,y_train),4)

round(cor(pred1,y_train)^2,4)

#Creation of alternative model
set.seed(rand_seed)
fit2<-neuralnet(f,data = data[train,],
                hidden = c(5,6),
                algorithm = "rprop+",
                err.fct = "sse",
                act.fct = "logistic",
                threshold = 0.01,
                rep = 1,
                linear.output = TRUE)

#Punctuation of second model
scores2<-compute(fit2,data[train,1:32])
pred2<-scores2$net.result

round(mse(pred2,y_train),4)

round(cor(pred2,y_train)^2,4)

#Creates third model with a higher number of repetitions
set.seed(rand_seed)
fit3<-neuralnet(f,
                data = data[train,],
                hidden = c(5,6),
                algorithm = "rprop+",
                err.fct = "sse",
                act.fct = "logistic",
                threshold = 0.01,
                rep = 10,
                linear.output = TRUE)

##Punctuation of different models for different repetitions of models fit3
#Model 1
scores3<-compute(fit3,data[train,1:32])
pred3_1=as.data.frame(fit3$net.result[1])
round(mse(pred3_1[,1],y_train),4)

round(cor(pred3_1[,1],y_train)^2,4)

#Model 2
pred3_2<-as.data.frame(fit3$net.result[2])
round(mse(pred3_2[,1],y_train),4)

round(cor(pred3_2[,1],y_train)^2,4)

#Plot describing the different models
pred3_1<-as.data.frame(fit3$net.result[1])
pred3_2<-as.data.frame(fit3$net.result[2])
pred3_3<-as.data.frame(fit3$net.result[3])
pred3_4<-as.data.frame(fit3$net.result[4])
pred3_5<-as.data.frame(fit3$net.result[5])
pred3_6<-as.data.frame(fit3$net.result[6])
pred3_7<-as.data.frame(fit3$net.result[7])
pred3_8<-as.data.frame(fit3$net.result[8])
pred3_9<-as.data.frame(fit3$net.result[9])
pred3_10<-as.data.frame(fit3$net.result[10])

r1<-round(cor(pred3_1[,1],y_train)^2,4)
r2<-round(cor(pred3_2[,1],y_train)^2,4)
r3<-round(cor(pred3_3[,1],y_train)^2,4)
r4<-round(cor(pred3_4[,1],y_train)^2,4)
r5<-round(cor(pred3_5[,1],y_train)^2,4)
r6<-round(cor(pred3_6[,1],y_train)^2,4)
r7<-round(cor(pred3_7[,1],y_train)^2,4)
r8<-round(cor(pred3_8[,1],y_train)^2,4)
r9<-round(cor(pred3_9[,1],y_train)^2,4)
r10<-round(cor(pred3_10[,1],y_train)^2,4)

rt<-rbind(r1,r2,r3,r4,r5,r6,r7,r8,r9,r10)
plot(rt)
View(rt)

#The models r8,r9 y r10 couldn´t be adjusted, therefore appear with error

#The model with better performance was the second model with a value of R-square de 0.8509
#The closer to 1, the better

#Suppose we use model 2, the one with higher performance withh the values of training data 

y_test=data[-train,33]
scores_test2<-compute(fit2,data[-train,1:32])
pred_test2=scores_test2$net.result

round(mse(pred_test2,y_test),4)

round(cor(pred_test2,y_test),4)

#The values of MSE and R squared are terribles, clearly a case of overfitting

#Checking how works the first model with test data
scores_test1<-compute(fit1,data[-train,1:32])
pred_test1=scores_test1$net.result

round(mse(pred_test1,y_test),4)

round(cor(pred_test1,y_test),4)


#Results are much better than the results obtained by model fit2

#Plot of the real values and adjusted
x<-c(0,31)
y<-c(0,7000)
plot(x,y,col="white",xlab = "Test Examples(Days)",ylab = "Numbers Registered")
lines(exp(pred_test1),col="red")
lines(exp(y_test),col="blue")