## =============================================================================
## Initialise and Load Libraries
## =============================================================================

## Clear memory
rm(list=ls())

## Libraries
library(ggplot2)
library(ggthemes)
library(dplyr)
# library(htmlwidgets)
# library(rbokeh)
library(directlabels)

## Load Pre-processed Data
load( file = "./data/preprocessed_data.rda")



## Big Four
row_use <- which(df_all$team %in% c("Arsenal", "Chelsea", "Man United", "Man City"))

ggplot(data = create_df(), aes(x = num_match, y = position, colour = team)) +
  geom_line() + scale_y_reverse() + facet_grid(team ~ season) +
  theme_bw() +
  xlab("Game Weeks (1-38)") +
  ylab("League Position (1-20)") +
  theme(legend.position="none") +
  labs(title = "League Position of Big Four since 2005")

## 4th Place
df_4th <- df_all[which(df_all$num_match == 38 & df_all$position == 4), c("season", "team")]
ggplot(df_4th, aes(factor(team), fill = team)) +
  geom_bar() +
  theme_bw() +
  xlab("Teams") +
  ylab("Number of Seasons") +
  theme(legend.position="none") +
  labs(title = "Number of Times Finishing Fourth")


## test reactive
input <- list()
input$team <- c("Arsenal", "Chelsea", "Man United", "Man City")
row_use <- which(df_all$team %in% input$team)



## rbokeh
df_temp <- df_all %>%
  filter(team == "Man City", num_match == 38) %>%
  group_by(season) %>%
  summarise(points = sum(cu_points))

p <- figure(width = 640, height = 480,
            title = "Manchester City's Performance since 2005",
            toolbar_location = "right",
            logo = "None") %>%
  tool_box_select() %>%
  tool_lasso_select() %>%
  ly_points(df_temp, hover = df_temp) %>%
  y_axis(label = "Total Points After 38 Matches") %>%
  x_axis(label = "Seasons",
         major_label_text_align = "left",
         major_label_orientation = 45)
p


## city arsenal
## rbokeh
df_arsenal <- df_all[which(df_all$team == "Arsenal" & df_all$season == "2010-2011"), c("num_match", "cu_points", "position")]
df_mancity <- df_all[which(df_all$team == "Man City" & df_all$season == "2010-2011"), c("num_match", "cu_points", "position")]

p1 <- figure(width = 640, height = 480,
             title = "Arsneal vs Man City (League Position)",
             toolbar_location = "right",
             xlab = "Matches",
             ylab = "League Position",
             logo = "None") %>%
  ly_lines(df_arsenal$num_match, df_arsenal$position, color = "red") %>%
  ly_lines(df_mancity$num_match, df_mancity$position, color = "blue")

p2 <- figure(width = 640, height = 480,
             title = "Arsneal vs Man City (Total Points)",
             toolbar_location = "right",
             xlab = "Matches",
             ylab = "Total Points",
             logo = "None") %>%
  ly_lines(df_arsenal$num_match, df_arsenal$position, color = "red") %>%
  ly_lines(df_mancity$num_match, df_mancity$position, color = "blue")

grid_plot(list(p1, p2))
