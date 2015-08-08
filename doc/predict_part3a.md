
<center><img src="30996_IMPORTANCE.jpg" alt="logo" width="300"></center>

<center><h2>Variable Importance Evaluation and Feature Selection</h2></center>

In order to evaluate the impact of each variable, I used a Random Forest model 
to calculate the mean decrease in accuracy score. The mean decrease in accuracy a 
variable causes is determined during the out of bag error calculation phase. 
The more the accuracy of the random forest decreases due to the exclusion 
(or permutation) of a single variable, the more important that variable is deemed, 
and therefore variables with a large mean decrease in accuracy are more important 
for classification of the data.

There are in total 13 variables:

Season, Month, Home Team, Away Team, B365H (Bet365's Odds of a Home Win), 
B365D (Bet365's Odds of a Draw), B365A (Bet365's Odds of an Away Win),
BWH, BWD, BWA (Bet & Win's Odds), VCH, VCD and VCA (WinVector's Odds).

<br>
