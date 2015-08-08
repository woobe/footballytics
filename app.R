## app.R ##
library(dplyr)
library(shiny)
library(shinydashboard)
library(ggplot2)
library(ggthemes)
library(htmlwidgets)
#library(rbokeh)
library(directlabels)
library(caret)

## Load Data
load(file = "./data/preprocessed_data.rda")


## =============================================================================
## UI
## =============================================================================
#####

ui <- dashboardPage(

  ## Header
  dashboardHeader(title = "Footballytics"),

  ## Skin
  skin = "blue",

  ## Sidebar content
  dashboardSidebar(

    sidebarMenu(

      menuItem("Introduction", tabName = "intro", icon = icon("futbol-o")),

      menuItem("Headline Stories", icon = icon("newspaper-o"),
               menuSubItem("The Rise of the City", tabName = "city", icon = icon("level-up")),
               menuSubItem("The Magic Numbers 33 & 43", tabName = "magic", icon = icon("sort-amount-desc")),
               #menuSubItem("The Great Escape", tabName = "tbc", icon = icon("life-ring")),
               menuSubItem("The 4th Place Specialist", tabName = "fourth", icon = icon("trophy"))),

      menuItem("Predictive Analytics", icon = icon("line-chart"),
               menuSubItem("Introduction", tabName = "predintro", icon = icon("line-chart")),
               menuSubItem("Data Preparation", tabName = "preddata", icon = icon("line-chart")),
               menuSubItem("Feature Selection", tabName = "predvarimp", icon = icon("line-chart")),
               menuSubItem("Building & Using a Model", tabName = "predmodel", icon = icon("line-chart"))),

      menuItem("Data Wrangling", icon = icon("database"),
               menuSubItem("Data Source", tabName = "datasource", icon = icon("table")),
               menuSubItem("R Code", tabName = "dataprep", icon = icon("code"))),
               #menuSubItem("Final Output", tabName = "tbc", icon = icon("table")),
               #menuSubItem("Download", tabName = "tbc", icon = icon("download"))),

      menuItem("External Links", tabName = "bib", icon = icon("external-link"),
               menuSubItem("Blog", icon = icon("external-link"), href = "http://blenditbayes.blogspot.co.uk/"),
               menuSubItem("GitHub", icon = icon("external-link"), href = "https://github.com/woobe")
      )

    )
  ),


  ## Body content
  dashboardBody(

    tabItems(

      # Intro
      tabItem(tabName = "intro",
              fluidPage(
              #fixedPage(#
                fluidRow(
                  column(width = 6, offset = 3,
                         includeMarkdown("doc/intro.md"))))),

      # The Rise of the City
      tabItem(tabName = "city",
              fluidPage(
              #fixedPage(
                fluidRow(
                  column(width = 10, offset = 1,
                         fluidPage(

                           ## Part One
                           includeMarkdown("doc/city_part1.md"),
                           sidebarLayout(
                             sidebarPanel(width = 3,
                                          selectInput("cityone", "Select a KPI:",
                                                      choices = c("Position", "Points", "Goals"),
                                                      selected = c("Position"),
                                                      multiple = FALSE)),
                             mainPanel(plotOutput("cityone"))),

                           ## Part Two
                           includeMarkdown("doc/city_part2.md"),
                           sidebarLayout(
                             sidebarPanel(width = 3,
                                          selectInput("citytwo", "Select a KPI:",
                                                      choices = c("Position", "Points"),
                                                      selected = c("Position"),
                                                      multiple = FALSE)),
                             mainPanel(plotOutput("citytwo"))),

                           ## Parts Three and Four
                           includeMarkdown("doc/city_part3.md"),
                           sidebarLayout(
                             sidebarPanel(width = 3,
                                          selectInput("citythree", "Select a KPI:",
                                                      choices = c("Points", "Goal Difference"),
                                                      selected = c("Points"),
                                                      multiple = FALSE)),
                             mainPanel(plotOutput("citythree"))),
                           includeMarkdown("doc/city_part4.md")
                         ))))),

      ## The 4th Place Specialist
      tabItem(tabName = "fourth",
              fluidPage(
              #fixedPage(
                fluidRow(
                  column(width = 10, offset = 1,
                         fluidPage(

                           ## Part One
                           includeMarkdown("doc/fourth_part1.md"),
                           sidebarLayout(
                             sidebarPanel(width = 3,
                                          selectInput("fourth", "Select a Final League Position:",
                                                      choices = c(1:6),
                                                      selected = c(4),
                                                      multiple = FALSE)),
                             mainPanel(plotOutput("fourth")))
                         ))))),



      ## Magic Numbers 33, 37, 40
      tabItem(tabName = "magic",
              fluidPage(
              #fixedPage(
                fluidRow(
                  column(width = 10, offset = 1,
                         fluidPage(

                           ## Part One
                           includeMarkdown("doc/magic_part1.md"),
                           sidebarLayout(
                             sidebarPanel(width = 3,
                                          selectInput("magic", "Select a Season:",
                                                      choices = c("2005-2006",
                                                                  "2006-2007",
                                                                  "2007-2008",
                                                                  "2008-2009",
                                                                  "2009-2010",
                                                                  "2010-2011",
                                                                  "2011-2012",
                                                                  "2012-2013",
                                                                  "2013-2014",
                                                                  "2014-2015"),
                                                      selected = c("2005-2006"),
                                                      multiple = FALSE),
                                          selectInput("bottom", "Show the Bottom n Teams:",
                                                      choices = c(2, 3, 4, 5),
                                                      selected = c(4),
                                                      multiple = FALSE)),
                             mainPanel(plotOutput("magic"))),
                           includeMarkdown("doc/magic_part2.md")
                         ))))),


      # Preditive Modelling Intro
      tabItem(tabName = "predintro",
              fluidPage(
              #fixedPage(
                fluidRow(
                  column(width = 10, offset = 1,
                         includeMarkdown("doc/predict_part1.md"))))),

      # Preditive Modelling Data
      tabItem(tabName = "preddata",
              fluidPage(
              #fixedPage(
                fluidRow(
                  column(width = 10, offset = 1,
                         includeMarkdown("doc/predict_part2.md"))))),

      # Preditive Modelling Var Imp
      tabItem(tabName = "predvarimp",
              fluidPage(
              #fixedPage(
                fluidRow(
                  column(width = 10, offset = 1,
                         includeMarkdown("doc/predict_part3a.md"),
                         verticalLayout(plotOutput("varimp")),
                         includeMarkdown("doc/predict_part3b.md"),
                         verticalLayout(plotOutput("rfe"))
                  )))),

      # Preditive Modelling Var Imp
      tabItem(tabName = "predmodel",
              fluidPage(
              #fixedPage(
                fluidRow(
                  column(width = 10, offset = 1,
                         includeMarkdown("doc/predict_part4a.md"),
                         verticalLayout(tableOutput("modelfinal")),
                         includeMarkdown("doc/predict_part4b.md"),
                         verticalLayout(tableOutput("predictions"))

                  )))),

      tabItem(tabName = "datasource",
              fluidPage(
              #fixedPage(
                fluidRow(
                  column(width = 10, offset = 1,
                         fluidPage(
                           includeMarkdown("doc/source_part1.md")
                         ))))),

      tabItem(tabName = "dataprep",
              fluidPage(
              #fixedPage(
                fluidRow(
                  column(width = 10, offset = 1,
                         fluidPage(
                           includeMarkdown("doc/dataprep_part1.Rmd")))))),

      tabItem(tabName = "tbc",
              fluidPage(
              #fixedPage(
                fluidRow(
                  column(width = 10, offset = 1,
                         fluidPage(
                           includeMarkdown("doc/tbc.md"))))))

      ## End
    )
  )
)


## =============================================================================
## Server
## =============================================================================
#####

server <- function(input, output) {

  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ## Reactive Functions here ...
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  ## City One
  plot_city_one <- reactive({

    if (input$cityone == "Points") {

      row_use <- which(df_all$team == "Man City" & df_all$num_match == 38)

      p <- ggplot(data = df_all[row_use, ], aes(x = season, y = cu_points)) +
        geom_point(size = 4) +
        #scale_y_reverse() +
        labs(title = "Man City's Total Points") +
        theme_fivethirtyeight() +
        theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
        xlab("Seasons") + ylab("Total Points after 38 Matches") +
        geom_text(aes(label = cu_points), hjust = -0.5, vjust = 0.5)

    } else if (input$cityone == "Position") {

      row_use <- which(df_all$team == "Man City" & df_all$num_match == 38)

      p <- ggplot(data = df_all[row_use, ], aes(x = season, y = position)) +
        geom_point(size = 4) +
        scale_y_reverse() +
        labs(title = "Man City's Final League Position") +
        theme_fivethirtyeight() +
        theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
        xlab("Seasons") + ylab("Final League Position") +
        geom_text(aes(label = position), hjust = -1, vjust = 0.5)

    } else if (input$cityone == "Goals") {

      df_temp <- df_all %>% filter(team == "Man City") %>%
        group_by(season) %>%
        summarise(goals = sum(goal_scored))

      p <- ggplot(data = df_temp, aes(x = season, y = goals)) +
        geom_point(size = 4) +
        labs(title = "Man City's Total Number of Goals") +
        theme_fivethirtyeight() +
        theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
        xlab("Seasons") + ylab("Total Number of Goals") +
        geom_text(aes(label = goals), hjust = -1, vjust = 0.5)

    }

    ## Return
    p

  })

  ## City Two
  plot_city_two <- reactive({

    if (input$citytwo == "Position") {

      row_use <- which(df_all$team %in% c("Man City", "Arsenal") & df_all$season == "2010-2011")
      ggplot(data = df_all[row_use, ], aes(x = num_match, y = position, colour = team)) +
        geom_line(linetype = "F1", size = 1) +
        labs(title = "Man City vs. Arsenal in Season 2010-2011") +
        theme_fivethirtyeight() +
        xlab("Seasons") + ylab("Final League Position") +
        xlim(0, 40) +
        geom_dl(aes(label = team), method = "smart.grid") +
        scale_colour_manual(values = c("#EF0107", "#5CBFEB")) +
        scale_y_reverse()

    } else {

      row_use <- which(df_all$team %in% c("Man City", "Arsenal") & df_all$season == "2010-2011")
      ggplot(data = df_all[row_use, ], aes(x = num_match, y = cu_points, colour = team)) +
        geom_line(linetype = "F1", size = 1) +
        labs(title = "Man City vs. Arsenal in Season 2010-2011") +
        theme_fivethirtyeight() +
        xlab("Seasons") + ylab("Points") +
        xlim(0, 40) +
        geom_dl(aes(label = team), method = "smart.grid") +
        scale_colour_manual(values = c("#EF0107", "#5CBFEB"))

    }

  })

  ## City Three
  plot_city_three <- reactive({

    if (input$citythree == "Points") {

      row_use <- which(df_all$team %in% c("Man United", "Man City") & df_all$season == "2011-2012")
      p <- ggplot(data = df_all[row_use, ], aes(x = num_match, y = cu_points, colour = team)) +
        geom_line(linetype = "F1", size = 1) +
        labs(title = "Manchester Clubs' Points in 2011-2012") +
        theme_fivethirtyeight() +
        xlab("Matches") + ylab("Points") +
        xlim(0, 40) +
        geom_dl(aes(label = team), method = "smart.grid") +
        scale_colour_manual(values = c("#5CBFEB", "#DA020E"))

    } else {

      row_use <- which(df_all$team %in% c("Man United", "Man City") & df_all$season == "2011-2012")
      p <- ggplot(data = df_all[row_use, ], aes(x = num_match, y = cu_goal_diff, colour = team)) +
        geom_line(linetype = "F1", size = 1) +
        labs(title = "Manchester Clubs' Goal Difference in 2011-2012") +
        theme_fivethirtyeight() +
        xlab("Seasons") + ylab("Final League Position") +
        xlim(0, 40) +
        geom_dl(aes(label = team), method = "smart.grid") +
        scale_colour_manual(values = c("#5CBFEB", "#DA020E"))
    }

    ## Return
    p

  })

  ## Fourth
  plot_fourth <- reactive({

    ## Extract Season
    row_use <- which(df_all$num_match == 38 & df_all$position == input$fourth)

    ## This is not ideal ... but works for now as a quick solution :)
    if (input$fourth == 1) txt_pos <- "First"
    if (input$fourth == 2) txt_pos <- "Second"
    if (input$fourth == 3) txt_pos <- "Third"
    if (input$fourth == 4) txt_pos <- "Fourth"
    if (input$fourth == 5) txt_pos <- "Fifth"
    if (input$fourth == 6) txt_pos <- "Sixth"

    ## Plot
    #ggplot(df_all[row_use, ], aes(team, fill = team)) + geom_bar() +
    ggplot(df_all[row_use, ]) + geom_bar(aes(factor(team), fill = team)) +
      labs(title = paste("No. of Times Finishing", txt_pos, "in Last 10 Seasons")) +
      ylim(0, 6) +
      theme_fivethirtyeight() + scale_colour_hc()
      #scale_colour_tableau()

  })

  ## Magic
  plot_magic <- reactive({

    ## Extract Season
    bottom_teams <- df_all[which(df_all$season == input$magic & df_all$num_match == 38 & df_all$position > (20 - as.numeric(input$bottom))), ]$team
    row_use <- which(df_all$season == input$magic & df_all$team %in% bottom_teams)
    max_y <- max(df_all[row_use,]$cu_points)

    ## Plot
    ggplot(data = df_all[row_use, ], aes(x = num_match, y = cu_points, colour = team)) +
      geom_line(linetype = "F1", size = 0.5) +
      labs(title = paste("Points of the Bottom Teams in Season", input$magic)) +
      theme_fivethirtyeight() +
      xlab("Matches") + ylab("Final League Position") +
      geom_hline(aes(yintercept = 33), type = "dotted") +
      geom_hline(aes(yintercept = 43), type = "dotted") +
      xlim(0, 45) + ylim(0, 45) +
      geom_dl(aes(label = team), method = "angled.endpoints") +
      scale_color_tableau()


  })



  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ## All Plots here ...
  ## Colours http://teamcolors.arc90.com/
  ## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  ## Plot City One
  output$cityone <- renderPlot({plot_city_one()})

  ## Plot City Two
  output$citytwo <- renderPlot({plot_city_two()})

  ## Plot City Three
  output$citythree <- renderPlot({plot_city_three()})

  ## Plot City Three
  output$fourth <- renderPlot({plot_fourth()})

  ## Plot Magic
  output$magic <- renderPlot({plot_magic()})

  ## Plot Var Imp
  output$varimp <- renderPlot({

    load(file = "./data/varimp.Rda")
    featureImportance <- data.frame(Feature=row.names(imp), Importance=imp[,1])
    ggplot(featureImportance, aes(x=reorder(Feature, Importance), y=Importance)) +
      geom_bar(stat="identity", fill="#53cfff") +
      coord_flip() +
      theme_light(base_size=20) +
      xlab("Importance") +
      ylab("") +
      ggtitle("Variable Importance Evaluation - Mean Decrease Accuracy") +
      theme(plot.title=element_text(size=18)) +
      theme_fivethirtyeight()

    })

  ## Plot RFE
  output$rfe <- renderPlot({

    load(file = "./data/model_rfe.Rda")
    results <- model_rfe$results
    ggplot(data = results, aes(x = Variables, y = Accuracy)) +
      geom_point(size = 3) +
      labs(title = "R.F.E. Results - Prediction Accuracy") +
      theme_fivethirtyeight() +
      xlim(9, 14) +
      geom_dl(aes(label = paste0(round(Accuracy,4)*100, "%")), method = "last.points")

  })

  ## Plot Model Final
  output$modelfinal <- renderTable({
    load(file = "./data/model_final.Rda")
    print(model_final, row.names = FALSE)
  })

  ## Plot Predictions
  output$predictions <- renderTable({

    load(file = "./data/predictions.Rda")

    df_correct <- matrix("No", nrow = 10)
    df_correct[which(yy_test == y_test),] <- "Yes"

    df_summary <- data.frame(x_test[, c("HomeTeam", "AwayTeam")],
                             Actual_Result = y_test,
                             Predicted_Result = yy_test,
                             Correct = df_correct)

    print(df_summary, row.names = FALSE)

  })


}


## =============================================================================
## Final
## =============================================================================
#####

shinyApp(ui, server)
