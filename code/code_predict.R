## Exploratory
rm(list=ls())

## Load Libraries
library(dplyr)
library(caret)
#library(predictr)
library(doParallel)

## Load CSV
## Source: http://www.football-data.co.uk/englandm.php
E0_2005 <- read.csv("./data/E0_2005.csv", stringsAsFactors = FALSE)
E0_2006 <- read.csv("./data/E0_2006.csv", stringsAsFactors = FALSE)
E0_2007 <- read.csv("./data/E0_2007.csv", stringsAsFactors = FALSE)
E0_2008 <- read.csv("./data/E0_2008.csv", stringsAsFactors = FALSE)
E0_2009 <- read.csv("./data/E0_2009.csv", stringsAsFactors = FALSE)
E0_2010 <- read.csv("./data/E0_2010.csv", stringsAsFactors = FALSE)
E0_2011 <- read.csv("./data/E0_2011.csv", stringsAsFactors = FALSE)
E0_2012 <- read.csv("./data/E0_2012.csv", stringsAsFactors = FALSE)
E0_2013 <- read.csv("./data/E0_2013.csv", stringsAsFactors = FALSE)
E0_2014 <- read.csv("./data/E0_2014.csv", stringsAsFactors = FALSE)

## These columns are available from 2005-2006 season
col_needed <- c("HomeTeam", "AwayTeam", "Date",
                "B365H", "B365D", "B365A",  ## bet365
                "BWH", "BWD", "BWA",        ## bet and win
                "VCH", "VCD", "VCA",        ## BetVictor
                "FTR")                      ## Full-time Results

## Combine Datasets
df_2005 <- data.frame(Season = "2005-2006", E0_2005[, col_needed])
df_2006 <- data.frame(Season = "2006-2007", E0_2006[, col_needed])
df_2007 <- data.frame(Season = "2007-2008", E0_2007[, col_needed])
df_2008 <- data.frame(Season = "2008-2009", E0_2008[, col_needed])
df_2009 <- data.frame(Season = "2009-2010", E0_2009[, col_needed])
df_2010 <- data.frame(Season = "2010-2011", E0_2010[, col_needed])
df_2011 <- data.frame(Season = "2011-2012", E0_2011[, col_needed])
df_2012 <- data.frame(Season = "2012-2013", E0_2012[, col_needed])
df_2013 <- data.frame(Season = "2013-2014", E0_2013[, col_needed])
df_2014 <- data.frame(Season = "2014-2015", E0_2014[, col_needed])
df_raw <- rbind(df_2005,df_2006, df_2007, df_2008, df_2009,
                df_2010, df_2011, df_2012, df_2013, df_2014)

## Convert to Factor
df_raw$Season <- as.factor(df_raw$Season)
df_raw$HomeTeam <- as.factor(df_raw$HomeTeam)
df_raw$AwayTeam <- as.factor(df_raw$AwayTeam)

## Convert Date to Month
df_raw$Date <- as.Date(df_raw$Date, "%d/%m/%y")
df_raw$Month <- as.factor(month(df_raw$Date))


## Split
col_predictors <- c("Season", "Month",
                    "HomeTeam", "AwayTeam",
                    "B365H", "B365D", "B365A",  ## bet365
                    "BWH", "BWD", "BWA",        ## bet and win
                    "VCH", "VCD", "VCA")        ## BetVictor

x_train <- df_raw[1:3790, col_predictors]
x_test <- df_raw[3791:3800, col_predictors]
y_train <- as.factor(df_raw[1:3790,]$FTR)
y_test <- as.factor(df_raw[-1:-3790,]$FTR)

library(randomForest)
set.seed(1234)
model <- randomForest(x_train, y_train,
                      mtry = 2,
                      ntree = 5000,
                      strata = y_train,
                      do.trace = TRUE,
                      importance = TRUE)
varImpPlot(model)
imp <- importance(model, type = 1)
save(imp, file = "./data/varimp.Rda")

## RFE
ctrl <- rfeControl(functions = rfFuncs,
                   method = "repeatedcv",
                   number = 5,
                   repeats = 1,
                   verbose = FALSE)

cl <- makePSOCKcluster(8)
registerDoParallel(cl)

set.seed(1234)
model_rfe <- rfe(x_train, y_train,
                 sizes = c(9:13),
                 rfeControl = ctrl)
print(model_rfe)

stopCluster(cl)

save(model_rfe, file = "./data/model_rfe.Rda")


## Final Model
ctrl <- trainControl(method = "repeatedcv",
                     number = 5,
                     repeats = 1)


cl <- makePSOCKcluster(8)
registerDoParallel(cl)
set.seed(1234)
model_final <- train(x_train, y_train,
                     method = "rf",
                     strata = y_train,
                     tuneLength = 3,
                     trControl = ctrl)
stopCluster(cl)
print(model_final)

save(model_final, file = "./data/model_final.Rda")

yy_train <- predict(model_final, x_train)
yy_test <- predict(model_final, x_test)

save(x_train, x_test, y_train, y_test, yy_train, yy_test, file = "./data/predictions.Rda")

