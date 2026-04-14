#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
library(dplyr)
library(ggplot2)
library(readr)
library(DT)

###################################################################
###################################################################
#Data Prep
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

###################################################################
###################################################################
# utilities  ===================================================================
load('utilities.rds') # loads two datasets

# dataset #1: Utilities data for every campus building (water, electricity, natural gas)

utility <- utilities %>% mutate(gal_person=gallons/capacity,
                                kwh_person=kwh/capacity,
                                therms_person=therms/capacity) %>%
  filter(type=="Residential - Residence Hall") %>%
  group_by(building, month) %>%
  summarize(gal_person= mean(gal_person,na.rm = TRUE),
            kwh_person= mean(kwh_person,na.rm = TRUE),
            therms_person= mean(therms_person,na.rm = TRUE))


###################################################################
###################################################################

# Define UI for application
ui <- fluidPage(# App title and description
  titlePanel("Who uses Sewanee Resources?"),
  h4("Exploring per-person utility usage across Sewanee residence halls"),
  p("Use this dashboard to compare water, electricity, and natural gas usage across residence halls over time. All metrics are divided by building capacity so halls of different sizes can be fairly compared."),
  helpText("Data source: Sewanee Facilities Management. Metrics are monthly averages per resident."),

  hr(),
    tabsetPanel(
      tabPanel(h5('Month series'),
               h2("Resource Usage Over Time"),
               p("Select a hall, a month range, and a resource metric to explore usage trends."),
             fluidRow(column(4, uiOutput('hall'),

                             radioButtons(inputId='rank',
                                          label= 'Rank Halls by..',
                                          choices= c('Alphabetically','Gallons per Person','Kwh per Person','Therms per Person'),
                                          selected= 'Alphabetically',
                                          inline=TRUE)),
                      column(4,
                             sliderInput(inputId = 'month',
                                         label= 'Select month...',
                                         min= min(utility$month),
                                         max= max(utility$month),
                                         value= range(utility$month))),
                      column(4,
                             radioButtons(inputId = 'yaxis',
                                          label= 'Select Y axis...',
                                          choices= names(utility)[3:5],
                                          selected= 'gal_person',
                                          inline=TRUE))
             ),
             br(),
             br(),
             br(),
             fluidRow(column(1),
                      column(10, plotOutput('uti')),
                      column(1))),
    tabPanel(h5('Data Viewer'),
             h2("Raw Data"),
             p("Browse the underlying dataset here. You can sort and search any column."),
             fluidRow(column(12, DTOutput('data')))))
  )

#################################################################

###################################################################
# SERVER
###################################################################
server <- function(input, output){

  # rv stores the filtered dataset and updates reactively
  rv <- reactiveValues()
  rv$utility <- utility

  # Observe updates rv$utility whenever the building selection changes
  observe({
    if(! is.null(input$building)){
      rv$utility <- utility %>% filter(building %in% input$building)
    }else{
      rv$utility <- utility
    }
  })

  # Render the hall selector dynamically so it can be reordered by the rank radio button
  output$hall <- renderUI({

    #by default rank
    halls <- utility %>% pull(building) %>% unique() %>% sort()

    # if input rank changed, then halls is changed
    if (input$rank == 'Gallons per Person') {
      halls <- utility %>%
        group_by(building) %>%
        summarize(gal = mean(gal_person, na.rm = TRUE)) %>%
        arrange(desc(gal)) %>%
        pull(building)

    # if input rank changed to kwh per person, halls is changed accordingly
    }else if (input$rank == 'Kwh per Person') {
      halls <- utility %>%
        group_by(building) %>%
        summarize(kwh = mean(kwh_person, na.rm = TRUE)) %>%
        arrange(desc(kwh)) %>%
        pull(building)

    # if input rank is changed to therms per person, halls is changed
    } else if (input$rank == 'Therms per Person') {
      halls <- utility %>%
        group_by(building) %>%
        summarize(therms = mean(therms_person, na.rm = TRUE)) %>%
        arrange(desc(therms)) %>%
        pull(building)
    }

    # halls here is determined by the inputrank which goes to the ui with uiOutput
    selectInput(
      inputId = 'building',
      label = 'Select Hall...',
      multiple = TRUE,
      choices = halls,
      selected = 'Ayres Hall'
    )
  })

  # Render the line plot, filtered by building and month range
  output$uti <- renderPlot({

    if(input$building %>% is.null){
      ggplot(rv$utility,
             aes_string(x = 'month',
                        y = input$yaxis,
                        color = 'building')) +
        geom_line() +
        xlim(input$month)
    }else{
      ggplot(rv$utility,
             aes_string(x = 'month',
                        y = input$yaxis,
                        color = 'building')) +
        geom_line() +
        xlim(input$month)
    }
  })

  # Render the data table
  output$data <- renderDT({ rv$utility })
}

# Run the application
shinyApp(ui = ui, server = server)
