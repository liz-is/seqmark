library(stringr)
library(foreach)
library(RColorBrewer)
library(ggplot2)
source("helpers.r")

shinyServer(function(input, output) {

    getSeq <- reactive({
        processSeq(input$plasmid)
    })
    getPattern <- reactive({
        processPatterns(input$patterns)
    })
    getMatches <- reactive({
        matchPatterns(getSeq(), getPattern(), matchCase = input$matchCase)
    })
    getColours <- reactive({
        brewer.pal(length(getPattern()), input$colours)
    })
    
    output$plasmidInfo <- renderText({ 
        paste("You have entered a sequence of", nchar(getSeq()), "bases.")
    })
    
    output$matchInfo <- renderText({ 
        out <- foreach(p = getPattern(), m = getMatches(), .combine = c) %do% 
            paste("For pattern", p, "there are", length(m)/nchar(p), "matches.")
        paste(out, collapse="\n")
    })
    
    output$plot <- renderPlot({
        colours <- colourCode(getSeq(), getMatches(), getColours())
        coords <- getCoords(getSeq(), input$plotWidth)
        makePlot(getSeq(), coords, colours)
    })
    
#     output$value <- renderPrint({
#         s <- processSeq(input$plasmid)
#         p <- processPatterns(input$patterns)
#         m <- matchPatterns(s,p, matchCase = TRUE)
#         colourCode(s,m, brewer.pal(length(p), "Dark2"))
#     })
 }
)