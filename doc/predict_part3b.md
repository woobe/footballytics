
<br>

<center><h2>Recursive Feature Elimination</h2></center>

From the evaluation results, we can see that the odds from brokers are quite important whereas
the Month information may not be of high predictive power. So the next question is 
whether I can improve the prediction accuracy by eliminating the less important variables.

In order to determine whether I should eliminate any variable or keep all of them, 
I used a method called Recursive Feature Elimination (RFE). The graph below shows 
the results from the RFE analysis. It turns out that models using all 13 features 
have the highest five-fold cross-validation accuracy (53.27%). 
Therefore, I am going to use all 13 features for the final model.

<br>
