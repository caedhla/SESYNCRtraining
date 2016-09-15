# Libraries
library(...)
library(...)

# Data
species <- read.csv("data/species.csv", stringsAsFactors = FALSE)
surveys <- read.csv("data/surveys.csv", na.strings = "", stringsAsFactors = FALSE)

# User Interface
in1 <- selectInput("pick_species",
                   label = "Pick a species",
                   choices = unique(species[["species_id"]]))
out2 <- plotOutput("species_plot")
side <- sidebarPanel("Options", in1)
main <- mainPanel(out3, out2)
out3<-  textOutput("species_name")
out4 <- dataTableOutput("species_plot_data")
tab <- tabPanel("Species", sidebarLayout(side, main))
tab2 <- tabPanel("Data", out4)
ui <- navbarPage(title = "Portal Project", tab, tab2)

# Server
server <- function(input, output) {
  output[["species_plot"]] <- renderPlot(
    surveys %>%
    filter(species_id== input[["pick_species"]]) %>% 
      ggplot(aes(year))+ 
      geom_bar()
  )
  output[["species_name"]] <- renderText(
    species %>%
      filter(species_id== input[["pick_species"]]) %>%
      select(genus, species) %>%
      paste(collapse=' ')
    )
  output[["species_plot_data"]] <- renderDataTable(
    surveys %>%
      filter(species_id== input[["pick_species"]])
    )
}
## can change order in tab for appearance

# Create the Shiny App
shinyApp(ui = ui, server = server)