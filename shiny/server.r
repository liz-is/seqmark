library(stringr)
library(foreach)
library(RColorBrewer)
library(ggplot2)
source("helpers.R")

shinyServer(function(input, output) {

    output$plasmidInfo <- renderText({ 
        seq <- processSeq(input$plasmid)
        paste("You have entered a sequence of", nchar(seq), "bases.")
    })
    
    output$matchInfo <- renderText({ 
        seq <- processSeq(input$plasmid)
        patterns <- processPatterns(input$patterns)
        matches <- matchPatterns(seq, patterns, matchCase = input$matchCase)
        
        out <- foreach(p = patterns, m = matches, .combine = c) %do% 
            paste("For pattern", p, "there are", length(m)/nchar(p), "matches.")
        paste(out, collapse="\n")
    })
    
    output$plot <- renderPlot({
        seq <- processSeq(input$plasmid)
        patterns <- processPatterns(input$patterns)
        matches <- matchPatterns(seq, patterns, matchCase = input$matchCase)
        
        pal <- getColours(patterns, input$colours)
        colours <- colourCode(seq, matches, pal)
        coords <- getCoords(seq, input$plotWidth)
        print(length(colours))
       makePlot(seq, coords, colours)
    })
    
#     output$value <- renderPrint({
#         s <- processSeq(input$plasmid)
#         p <- processPatterns(input$patterns)
#         m <- matchPatterns(s,p, matchCase = TRUE)
#         colourCode(s,m, brewer.pal(length(p), "Dark2"))
#     })
 }
)