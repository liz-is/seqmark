library(RColorBrewer)

shinyUI(fluidPage(
    titlePanel("Colour Coding DNA Sequences!"),
    ##INPUT
    sidebarPanel(
        helpText("Enter your sequence here:"),
        #plasmid input
        tags$textarea(id="plasmid", 
                      rows=10, cols=40),
        br(),
        
        #patterns input
        textInput("patterns", 
                    label = "Patterns to match, comma separated",
                    value="e.g. CG"),
        br(),
        
        #match case
        checkboxInput("matchCase", 
                      label = "Match case?", 
                      value = TRUE),
        br(), 
        br(),
        
        h3("Plot Options"),
        br(),
        #plot width
        #numeric input
        numericInput("plotWidth", 
                     label = "Plot width in characters", 
                     value = 100),
        br(),
        
        #palette choice
        #later see here https://github.com/bchartoff/ggShinyApp
        selectInput("colours", 
                    label = "Colour palette", 
                    choices = rownames(brewer.pal.info),
                    selected = "Dark2")
    ),
     
    mainPanel(
         plotOutput("plot", width = "100%", height = "800px"),
         br(),
         textOutput("plasmidInfo"),
         br(),
         textOutput("matchInfo"),
         br()
         )   
))