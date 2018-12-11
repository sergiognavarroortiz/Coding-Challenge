# Coding-Challenge
Codes of Deep Learning and Optimization

This file i recommend to run it in RStudio 3.5.1 using Windows 10

The following code contains the solution to the problem called
"Smart Exploration Problem", this problem was solved with R.

The code generic, in order to represent how could be the solution of this
problem and in this code the code is commented, this is with the intention
to explain each codified line.

Since this problem didn´t include real data, this code won´t run as is. 
Code must be adapted depending the particular kind of data used.

Initially, I made an Exploratory Analysis, wher it was found that the 
variables are useful for the prediction of "Unknown Metrics", next, I made sudies 
of correlation among known variables and unknown variables, with the 
intention to determine the order of variables to predict. Being the first
prediction the variable that has higher correlation and so on until 
going for the prediction of variable CPE.

The next step was to create a Model of Prediction the Deep Neural Networks
(Deep Learning), stariting this phase with the normalization of data in order 
to have a precise Prediction. In this section it was specified some values
commonly used y some other the depend of the experience of programmer, such as
the hidden layers and number of neurons per hidden layer.

Finally, with the already predicted values, I started the last phase, which
is the Optimization of the Model, where the goal was to minimze the value of 
CPE considering the rest of variables, somo of them categorical and some other
numeric. For this process I used Genetic Algorithm with a Linear Regression 
Function. I have to note, that this process is just illustrative, since no
real data was given to me. therefore, to find the most adequate function was
hypothetical, let´s note that some other algorithms will work better, but 
always it must be considered the nature of each dataset provided. But this
code is a good example of solution for a real situation.

So, in a way of final comment, I recommend the use of Deep Learning for 
solving situations like these, but I have knowledege of Machine Learning, as well 
as methods of Optimization, such as:

Blind Search: Full Blind Search, Grid Search, Monte Carlo Search

Local Search: Hill Climbing, Simulated Annealing, Tabu Search

Population Based Search: Genetic and Evolutionary Algorithms, Differential Evolution, Particle Swarm Optimization, Estimation of Distribution Algorithm, Comparison of Population Besed Methods, Bag Prices with Constraint, Genetic Programming

Multi-Objetive Optimization: Weighted-Formula Approach, Lexicographic Approach, Pareto Approach

