##########################################
# Option 1: Crude Estimation of Property #
##########################################

#Regarding the situation of affecting the accuracy of the model directly, I must comment that the effect
#of the size of the data is mediated by the degree of freedom (DoF) of the model, which results in the
#phenomenon of the association between precision and the DoF. The existence of the association of precision-DoF
#signals the problem of lack of adaptation and has as a characteristic a large bias of prediction, which,
#consequently, restricts the precise prediction in unknown domains.

#I suggest the incorporation of Crude Estimation of Property in the feature space, in order to establish
#ML models using small sized data, this will increase the accuracy of prediction without the cost of
#higher DoF.

#When I consider the integration of the crude estimate, the predictive capacity of machine learning models
#at advanced levels effectively improved, showing the importance and the generality of the proposed
#strategy to build accurate machine learning models using small sets of data.

#In the case of the model was trained using limited available data: I have observed the association
#between the degree of freedom (DoF) of model and the precision of prediction, that is, the higher
#precision is, the higher DoF. This is originated from the statistical bias-variance tradeoff, therefore,
#the appearance of precision-DoF association is a restriction for the accuracy of prediction in unknown
#domains.


###############################
# Option 2: Transfer Learning #
###############################

#Based on the data provided in the table of the Coding Challenge, Transfer Learning can be a good option; since, with the
#variables of which, if they gave us information, they can be pre-trained for relations between them. This
#way, although there is little data, of the variables Lifetime_Spend, Lifetime_Clicks and Lifetime_Engagements,
#the variable CPE can be predicted.

#Transfer Learning works in the following way: pre-training of the variables with which they give me more
#information, so that we can find the relationships that exist between them. Subsequently, with the variables
#that have less amount of information, the Prediction Model is generated, where the number of Predictors
#is reduced, since we had a previous Model of pre-training, in this way, I can generate Machine Learning Models,
#although it has little data.

#Suppose I want to predict through images, what a brand logo is about; Normally for this task, using
#Deep Learning, between 1M and 1.4M of images are required, but using Transfer Learning, only between 4K and 5K
#of images are required. Which means a Data Reduction of 99.6%, this is a very noticeable reduction.


##################################
# Option 3: Combining Predictors #
##################################

# Another option is, to combine predictors, so we can reduce overfitting and bias. 

#Combining Predictor consists in that two or more variables of Prediction become only one variable, but more
#powerful that will help me to have an accurate prediction; this help to reduce the degrees of freedom, so 
#if I have fewer variables of Prediction, then I will have the advantage of needing a lower amount of data.

# Sample code #

#Using packages
library(ggplot2);library(caret);

#Create a building data set validation set
inBuild<-createDataPartition(y=data$Lifetime_Spend, p=0.7,list=FALSE)
validation<-data[-inBuild,];buildData<-data[inBuild,]
inTrain<-createDataPartition(y=buildData$Lifetime_Spend, p=0.7, list=FALSE)
training<-buildData[inTrain,];testing<-buildData[-inTrain,]

#Create the models
mod1<-train(Lifetime_Spend~.,method="glm",data=training)
mod2<-train(Lifetime_Spend~.,method="rf",data=training,trControl=trainControl(method="cv",number=3))   #cv is for generating a validation, so it can be compared

#Prediction
pred1<-predict(mod1,testing);pred2<-predict(mod2,testing)

#Comparative plot
qplot(pred1,pred2,colour=Lifetime_Spend,data=testing)

#Combining a model which combines predictors
predDf<-data.frame(pred1,pred2,wage=testing$wage)
combModFit<-train(Lifetime_Spend~.,method="gam",data=predDf)
combPred<-predict(combModFit,predDf)

#Testing errors
sqrt(sum((pred1-testing$Lifetime_Spend)^2))   #Modelo 1
sqrt(sum((pred2-testing$Lifetime_Spend)^2))   #Modelo 2
sqrt(sum((combPred-testing$Lifetime_Spend)^2))   #Modelo 3

#Prediction in validation of data (This is to test real error)
pred1V<-predict(mod1,validation);pred2V<-predict(mod2,validation)
predVDF<-data.frame(pred1=pred1V,pred2=pred2V)
combPredV<-predict(combModFit,predVDF)

#Testing errors in validation of dataset
sqrt(sum((pred1V-validation$Lifetime_Spend)^2))
sqrt(sum((pred2V-validation$Lifetime_Spend)^2))
sqrt(sum((combPredV-validation$Lifetime_Spend)^2))


###############################
# Option 4: Data Augmentation #
###############################

# In case that the images that were used to carry out advertising have a high relation with the variable
#CPE (the variable to predict), then we could make use of Data Augmentation, where the idea is to generate
#duplicates, triplicates or more of the same data, but varying the image; This means that the images are
#rotated, inverted, scaled, cut, moved, etc.

#This, of course, if the image varies, according to the CPE and is not constant, as you consider from
#the beginning in the Coding Challenge document.


# Example of Code #

#Create subsets to manipulate each image
img1<-subset(data, data$Preview_Image=="img1")
img2<-subset(data,data$Preview_Image=="img2")
.
.
.
imgn<-subset(data,data$Preview_Image=='imgn')

#Rotation of the image in each subset
img1_flip<-flipImage(img1$Preview_Image, mode = "horizontal")
img1<-select(img1,-Preview_Image)
img1$Preview_Image=img1_flip
.
.
.
imgn_flip<-flipImage(imgn$Preview_Image, mode = "horizontal")
imgn<-select(imgn,-Preview_Image)
imgn$Preview_Image=imgn_flip

#Union of new data with the original data
data_new <- Reduce(function(...) merge(...,all=T), list(img1,.......,imgn,data))

# This same process can be done to invert, scale, cut, move, etc, to the images.

#Over-fitting usually happens when your neural network tries to learn high frequency features 
#(patterns that occur a lot) that may not be useful. The already mentioned procedure can cause this
#problem and for that 'Gaussian noise', which has zero mean, essentially has data points in all
#frequencies, effectively distorting the high frequency features.

#Additionally, to these techniques, Advanced Augmentation Techniques are available as Conditional GANs.
#For this example, we will only leave the previous code for illustrative purposes. I hope
#that the concept could be shown adequately.

#Finally, with the new data and keeping the same prediction variables, you can perform
#the process of deep neural networks.


############
# Option 5 #
############

#In case the amount of data is very small, Deep Learning could not execute very well. Therefore,
#statistical techniques can be carried out to help make models with a good fit, without falling into
#overfitting. As an example of these types of models, I can mention Bootstrapping and also Monte Carlo
#cross validation.

#I generated a linear model, considering that the amount of data is very small, because a complex model
#could cause an overfitting problem.

# Sample code #


# Bootstrap 95% CI for regression coefficients 
library(boot)
# function to obtain regression weights 
bs <- function(formula, data, indices) {
  d <- data[indices,] # allows boot to select sample 
  fit <- lm(formula, data=d)
  return(coef(fit)) 
} 
# bootstrapping with 1000 replications 
results <- boot(data=data, statistic=bs,  #statistic can be any function, which, when applied to data returns a vector containing the statistic(s) of interest
                R=1000, formula=Lifetime_Spend~Channel+Preview_Headline+Channel_Ad_ID+Gender_Targeting+
                  Age_Targeting+Device_Targeting+Interest_Targeting)

# view results
results
plot(results, index=1) # intercept 
plot(results, index=2) # Channel 
plot(results, index=3) # Preview_Headline
plot(results, index=4) # Channel_Ad_ID
plot(results, index=5) # Gender_Targeting
plot(results, index=6) # Age_Targeting
plot(results, index=7) # Device_Targeting
plot(results, index=8) # Interest_Targeting


# get 95% confidence intervals 
boot.ci(results, type="bca", index=1) # intercept 
boot.ci(results, type="bca", index=2) # Channel 
boot.ci(results, type="bca", index=3) # Preview_Headline
boot.ci(results, type="bca", index=4) # Channel_Ad_ID 
boot.ci(results, type="bca", index=5) # Gender_Targeting
boot.ci(results, type="bca", index=6) # Age_Targeting 
boot.ci(results, type="bca", index=7) # Device_Targeting
boot.ci(results, type="bca", index=8) # Interest_Targeting 





