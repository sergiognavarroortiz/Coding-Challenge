# OPTIMIZATION
Genetic and evolutionary algorithms, which are known as population-based search algorithms, use a pool of candidate solutions instead of just a single search point. Because of this, population-based methods tend to require more calculations when compared to simpler local methods, although they tend to work better as global optimization methods, quickly finding regions that are interested in the search space.

Population-based methods have the tendency to explore the most distinct regions of the search space, as compared to single-state methods. Therefore, these algorithms can achieve greater diversity in terms of configuration of new ones. The solutions, which can be created not only by changing each individual search point slightly but also by combining attributes related to two (or more) search points.

Evolutionary computation is distinguished by several optimization algorithms inspired by the phenomenon of natural selection and that include a population of competing solutions. Although it is not always clearly defined, how these methods are distinguished, are mainly based on how to represent a solution and how new solutions are created.

Genetic algorithms often have applications that are focused on the solution of global optimization problems. It is because this is used as optimization algorithm, and considering that I wasn´t provided with real data in the Coding Challenge. 
So, this algorithm, based in its characteristics, that I have already mentioned, could lead to the solution of the second part of the Coding Challenge.
Now, with regard to the exercise number 2 of the Coding Challenge, the categorical variables were converted into numerical variables so that the optimization will work more quickly.
I made the adjustment of the function for the genetic algorithm, in line 290 of the document "Coding Challenge", is where we can see that the function is linear of 14 variables. For this, the elimination of some variables was considered and the rest were kept in a standardized way (procedures performed in the "Exploratory Analysis of the variables" section).
I consider a linear function, because it is a simple method to start a prediction study, in addition to containing 14 prediction variables and considering that there would be little data, it is not convenient to use a more complex function since this could cause an overfit of the model and therefore make a bad prediction in a real case. I never meant that this algorithm, necessarily is, always, the best solution. The best algorithm to choose depends on the characteristics of the data provided by the client.



I currently have mastery in modern optimization methods, such as:

- Blind Search: Full Blind Search, Grid Search, Monte Carlo Search
- Local Search: Hill Climbing, Simulate Annealing, Tabu Search
- Population Based Search: Genetic and Evolutionary Algorithms, Differential Evolution, Particle Swarm Optimization, Estimate of Distribution Algorithm
- Multi-Objective Optimization: Weighted-Formula Approach, Lexicographic Approach, Pareto Approach


