# Coding-Challenge

The following code contains the solution to the problem called "Smart Exploration Problem", this problem was solved with R.

The code generic, in order to represent how could be the solution of this problem and in this code the code is commented, this is with the intention to explain each codified line.

Since this problem didn´t include real data, this code won´t run as is.  Code must be adapted depending the particular kind of data used.

# Requirements

- RStudio 1.1.1442  
https://www.rstudio.com/products/rstudio/download/#download
- R compiler 3.5.1
https://cran.r-project.org/mirrors.html

This code was run in Windows 10 Home Single Language 
https://www.microsoft.com/en-us/windows

## Exploratory analysis of the variables

Initially, I made an Exploratory Analysis, where it was found that the  variables are useful for the prediction of "Unknown Metrics", next, I made studies  of correlation among known variables and unknown variables, with the intention to determine the order of variables to predict. Being the first prediction, the variable that has higher correlation and so on,  going for the prediction of variable CPE.

## Prediction Model with Deep Neural Networks (Deep Learning)

The next step was to create a Model of Prediction the Deep Neural Networks (Deep Learning), stariting this phase with the normalization of data in order  to have a precise Prediction. In this section it was specified some values commonly used y some other the depend of the experience of programmer, such as the hidden layers and number of neurons per hidden layer.


## Optimization of the Model

Finally, with the already predicted values, I started the last phase, which is the Optimization of the Model, where the goal was to minimze the value of CPE considering the rest of variables, somo of them categorical and some other numeric. For this process I used Genetic Algorithm with a Linear Regression  Function. I have to note, that this process is just illustrative, since no real data was given to me. therefore, to find the most adequate function was hypothetical, let´s note that some other algorithms will work better, but  always it must be considered the nature of each dataset provided. But this code is a good example of solution for a real situation.


# Finals comments
I recommend the use of Deep Learning for solving situations like these, since that I am using Deep Learning, it can be mixed categorical variables and numeric variables for Prediction purposes and considering the power that Deep Learning has for Prediction of variables. The Optimization methods could be used for many objectives and approaches, but considering that real data wasn´t provided, I used an algorithm that can show clearly the methodology for solving this problem, but this method is not in any way, the solution for every case.

