## =============================================================================
## Initialise and Load Libraries
## =============================================================================

## Clear memory
rm(list=ls())


## =============================================================================
## Load Source Data and Combine
## =============================================================================

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
                "FTHG", "FTAG", "FTR",
                "HTHG", "HTAG", "HTR",
                "HS", "AS", "HST", "AST",
                "HF", "AF", "HC", "AC",
                "HY", "AY", "HR", "AR" ,
                "B365H", "B365D", "B365A",  ## bet365
                "BWH", "BWD", "BWA",        ## bet and win
                "WHH", "WHD", "WHA",        ## William Hill
                "VCH", "VCD", "VCA")        ## BetVictor

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

## Convert Date
df_raw$Date <- as.Date(df_raw$Date, "%d/%m/%y")


## =============================================================================
## Extract Key Stats
## =============================================================================

## Helper function
extract_stats <- function(df_raw, n_season = NULL) {

  ## Display
  cat("Extracting Stats for Season", n_season, "...\n")

  ## Extract season
  row_season <- which(df_raw$Season == n_season)
  df_season <- df_raw[row_season, ]

  ## Extract unique team names
  all_teams <- sort(unique(as.character(as.factor(df_season$HomeTeam))))

  ## Empty Shell
  df_output <- c()

  ## Main Loop[]
  for (n_team in 1:20) {

    ## Extract
    temp_team <- all_teams[n_team]

    ## Extract Home Stats
    row_home <- which(df_season$HomeTeam == temp_team)

    df_home <- data.frame(season = n_season,
                          date = df_season[row_home, ]$Date,

                          ## Team
                          team = df_season[row_home, ]$HomeTeam,
                          venue = "home",
                          opponent = df_season[row_home, ]$AwayTeam,

                          ## Goals
                          goal_scored = df_season[row_home, ]$FTHG,
                          goal_conceded = df_season[row_home, ]$FTAG,
                          goal_diff = df_season[row_home, ]$FTHG - df_season[row_home, ]$FTAG,

                          ## Attack
                          shot = df_season[row_home, ]$HS,
                          on_target = df_season[row_home, ]$HST,
                          on_target_rate = df_season[row_home, ]$HST / df_season[row_home, ]$HS,
                          hit_rate = df_season[row_home, ]$FTHG / df_season[row_home, ]$HS,

                          ## Defense
                          shot_opp = df_season[row_home, ]$AS,
                          on_target_opp = df_season[row_home, ]$AST,
                          on_target_rate_opp = df_season[row_home, ]$AST / df_season[row_home, ]$AS,
                          hit_rate_opp = df_season[row_home, ]$FTAG / df_season[row_home, ]$AS,

                          ## Fouls
                          foul_commited = df_season[row_home, ]$HF,
                          foul_received = df_season[row_home, ]$AF,
                          foul_ratio = df_season[row_home, ]$HF / df_season[row_home, ]$AF,
                          yellow = df_season[row_home, ]$HY,
                          yellow_opp = df_season[row_home, ]$AY,
                          red = df_season[row_home, ]$HR,
                          red_opp = df_season[row_home, ]$AR,

                          ## Corners
                          corner_awarded = df_season[row_home, ]$HC,
                          corner_conceded = df_season[row_home, ]$AC)

    ## Extract Away Stats
    row_away <- which(df_season$AwayTeam == temp_team)

    df_away <- data.frame(season = n_season,
                          date = df_season[row_away, ]$Date,

                          ## Team
                          team = df_season[row_away, ]$AwayTeam,
                          venue = "away",
                          opponent = df_season[row_away, ]$HomeTeam,

                          ## Goals
                          goal_scored = df_season[row_away, ]$FTAG,
                          goal_conceded = df_season[row_away, ]$FTHG,
                          goal_diff = df_season[row_away, ]$FTAG - df_season[row_away, ]$FTHG,

                          ## Attack
                          shot = df_season[row_away, ]$AS,
                          on_target = df_season[row_away, ]$AST,
                          on_target_rate = df_season[row_away, ]$AST / df_season[row_away, ]$AS,
                          hit_rate = df_season[row_away, ]$FTAG / df_season[row_away, ]$AS,

                          ## Defense
                          shot_opp = df_season[row_away, ]$HS,
                          on_target_opp = df_season[row_away, ]$HST,
                          on_target_rate_opp = df_season[row_away, ]$HST / df_season[row_away, ]$HS,
                          hit_rate_opp = df_season[row_away, ]$FTHG / df_season[row_away, ]$HS,

                          ## Fouls
                          foul_commited = df_season[row_away, ]$AF,
                          foul_received = df_season[row_away, ]$HF,
                          foul_ratio = df_season[row_away, ]$AF / df_season[row_away, ]$HF,
                          yellow = df_season[row_away, ]$AY,
                          yellow_opp = df_season[row_away, ]$HY,
                          red = df_season[row_away, ]$AR,
                          red_opp = df_season[row_away, ]$HR,

                          ## Corners
                          corner_awarded = df_season[row_away, ]$AC,
                          corner_conceded = df_season[row_away, ]$HC)

    ## Combine Home and Away
    df_team <- rbind(df_home, df_away)
    df_team <- df_team[order(df_team$date), ]

    ## Add Match (Game Week) Number
    df_team <- data.frame(df_team[, 1:3],
                          num_match = 1:38,
                          df_team[, -1:-3])

    ## Add Cumulative Goal Difference
    df_team$cu_goal_diff <- 0
    df_team[1, ]$cu_goal_diff <- df_team[1, ]$goal_diff
    for (n_match in 2:38) {
      df_team[n_match, ]$cu_goal_diff <- df_team[(n_match-1), ]$cu_goal_diff + df_team[n_match, ]$goal_diff
    }

    ## Add Cumulative Points
    df_team$points <- 0
    df_team[which(df_team$goal_diff > 0), ]$points <- 3
    df_team[which(df_team$goal_diff == 0), ]$points <- 1

    df_team$cu_points <- 0
    df_team[1, ]$cu_points <- df_team[1, ]$points
    for (n_match in 2:38) {
      df_team[n_match, ]$cu_points <- df_team[(n_match-1), ]$cu_points + df_team[n_match, ]$points
    }

    ## Add W/D/L
    df_team$result <- NA
    df_team[which(df_team$points == 3), ]$result <- "Win"
    df_team[which(df_team$points == 1), ]$result <- "Draw"
    df_team[which(df_team$points == 0), ]$result <- "Loss"

    ## Add Points + Goal Difference (for league position)
    df_team$points_w_goaldiff <- 0
    df_team$points_w_goaldiff <- df_team$cu_points + df_team$cu_goal_diff / 1000 + df_team$on_target / 1000000

    ## Save it to the overall data frame
    df_output <- rbind(df_output, df_team)

  }

  ## Return
  return(df_output)

}

## Extract stats for individual seasons
df_stats_2005 <- extract_stats(df_raw, n_season = "2005-2006")
df_stats_2006 <- extract_stats(df_raw, n_season = "2006-2007")
df_stats_2007 <- extract_stats(df_raw, n_season = "2007-2008")
df_stats_2008 <- extract_stats(df_raw, n_season = "2008-2009")
df_stats_2009 <- extract_stats(df_raw, n_season = "2009-2010")
df_stats_2010 <- extract_stats(df_raw, n_season = "2010-2011")
df_stats_2011 <- extract_stats(df_raw, n_season = "2011-2012")
df_stats_2012 <- extract_stats(df_raw, n_season = "2012-2013")
df_stats_2013 <- extract_stats(df_raw, n_season = "2013-2014")
df_stats_2014 <- extract_stats(df_raw, n_season = "2014-2015")

## Combine
df_stats_all <- rbind(df_stats_2005, df_stats_2006, df_stats_2007, df_stats_2008, df_stats_2009,
                      df_stats_2010, df_stats_2011, df_stats_2012, df_stats_2013, df_stats_2014)

## Clean up a bit before moving on
rm(df_2005, df_2006, df_2007, df_2008, df_2009,
   df_2010, df_2011, df_2012, df_2013, df_2014)

rm(E0_2005, E0_2006, E0_2007, E0_2008, E0_2009,
   E0_2010, E0_2011, E0_2012, E0_2013, E0_2014)


## =============================================================================
## Summary Table for League Position and Goal Difference
## =============================================================================

## Helper function
extract_pos <- function(df_season) {

  ## Display
  cat("Extracting League Position for Season", as.character(df_season[1, ]$season), "...\n")

  ## Extract Teams
  all_teams <- sort(unique(as.character(as.factor(df_season$team))))

  ## Temp data frame for points
  df_temp <- data.frame(matrix(NA, nrow = 38, ncol = 21))
  colnames(df_temp) <- c("game_week", all_teams)
  df_temp$game_week <- 1:38
  df_temp[, -1] <- 0

  ## Update points (with goal difference and shots on target combo score)
  for (n_team in 1:20) {

    ## Extract Team
    temp_team <- all_teams[n_team]
    row_team <- which(df_season$team == temp_team)

    ## Assign points + goal differece + shots on target combo score
    df_temp[, temp_team] <- df_season[row_team, ]$points_w_goaldiff

  }

  ## Update League Position
  df_pos <- data.frame(matrix(NA, nrow = 38, ncol = 21))
  colnames(df_pos) <- c("game_week", all_teams)
  df_pos$game_week <- 1:38
  df_pos[, -1] <- 0

  for (n_week in 1:38) {
    df_temp_pos <- data.frame(team = t(sort(df_temp[n_week, -1], decreasing = TRUE)), pos = 1:20)
    df_pos[n_week, -1] <- df_temp_pos[all_teams,]$pos
  }

  ## Reshape
  df_output <- c()
  for (n_team in 1:20) {

    temp_team <- all_teams[n_team]
    df_temp_output <- data.frame(team = temp_team,
                                 week = 1:38,
                                 cu_points = df_temp[, (n_team + 1)],
                                 position = df_pos[, (n_team + 1)])
    df_output <- rbind(df_output, df_temp_output)

  }

  ## Add Goal Difference
  df_output$cu_goal_diff <- df_season$cu_goal_diff

  ## Return
  return(df_output)

}

## Extract points and league position
df_pos_2005 <- data.frame(season = "2005-2006", extract_pos(df_stats_2005))
df_pos_2006 <- data.frame(season = "2006-2007", extract_pos(df_stats_2006))
df_pos_2007 <- data.frame(season = "2007-2008", extract_pos(df_stats_2007))
df_pos_2008 <- data.frame(season = "2008-2009", extract_pos(df_stats_2008))
df_pos_2009 <- data.frame(season = "2009-2010", extract_pos(df_stats_2009))
df_pos_2010 <- data.frame(season = "2010-2011", extract_pos(df_stats_2010))
df_pos_2011 <- data.frame(season = "2011-2012", extract_pos(df_stats_2011))
df_pos_2012 <- data.frame(season = "2012-2013", extract_pos(df_stats_2012))
df_pos_2013 <- data.frame(season = "2013-2014", extract_pos(df_stats_2013))
df_pos_2014 <- data.frame(season = "2014-2015", extract_pos(df_stats_2014))

## Combine
df_pos_all <- rbind(df_pos_2005, df_pos_2006, df_pos_2007, df_pos_2008, df_pos_2009,
                    df_pos_2010, df_pos_2011, df_pos_2012, df_pos_2013, df_pos_2014)

## =============================================================================
## Combine ALL!
## =============================================================================

if (identical(df_stats_all$team, df_pos_all$team)) {
  df_all <- data.frame(df_stats_all, position = df_pos_all$position)
}


## =============================================================================
## Save all to disk
## =============================================================================

cat("\nSaving the summary data frame to file ...")
save(df_all, file = "./data/preprocessed_data.rda")
cat(" All Done!!!\n")
