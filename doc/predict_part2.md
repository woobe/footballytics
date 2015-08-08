
<center><img src="pencil.jpg" alt="logo" width="300"></center>

<center><h2>Data Preparation</h2></center>

Building predictive models is all about knowing the predictors and targets. 
This section explains how those variables are chosen from the source data. 
The data cleansing process can be found at the "Data Wrangling" section so I am not going to repeat them here.

<center><h2>Predictors</h2></center>

Predictors are variables that can be used to predict the value of another variable (as in statistical regression).
In order to keep the process consistent, I have chosen variables with complete records throughout
the ten Premier League seasons. Those variables are:

- Season
- Date (as in Month)
- Home Team
- Away Team
- Odds (Home, Draw, Away) from sports brokers - Bet365, Bet & Win and Bet Victor.

Other variables in the dataset like the number of shots, corners, fouls and cards might also be useful for predicting outcomes.
However, these variables are unknown prior to the matches so I am going to exclude them for now. 
Of course there are ways to capture the predictive power of these variables (for example, 
using seasonal average values instead of actual values) but I will skip that process for this simple example.

<center><h2>Targets</h2></center>

What outcomes do we want to predict? 
There are many outcomes from a football match (that you can put a bet on).
From correct score, first goalscorer to the number of corners.
Yet, I always believe less is more. In order to keep this demo example simple, 
I have chosen to predict the full-time result which is either a **Home Win**, a **Draw** or an **Away Win**.

Although the 2014-2015 season is already over, I can still demonstrate the process 
as if we were to predict the outcomes in the final week. So, for that purpose, 
I have split the datasets like this:

- **Training and Cross-Validation**: Week 1 in Season 2005-2006 to Week 37 in Season 2014-2015 (**3790 samples**)
- **Testing**: Week 38 in Season 2014-2015 (**10 samples**)

<center><h2>Caveat</h2></center>

As I mention earlier, this demo is rather simplistic. If you want to find out how 
I used a similar but more advanced approach for correct score prediction, please 
see my previous project [here](https://github.com/woobe/wc2014).

<br>



