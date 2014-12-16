processSeq <- function(seq){
    paste(str_trim(strsplit(seq, "[[:space:]]")[[1]]), collapse="")
}


#input patterns text processing
processPatterns <- function(patterns){
    str_trim(strsplit(patterns, ",")[[1]])

}

#get matches
matchPatterns <- function(seq, patterns, matchCase = TRUE){
    
    if (!matchCase){ patterns <- ignore.case(patterns)}
    
    positions <- str_locate_all(seq, fixed(patterns))
    
    patterns.idx <- foreach(pos=positions) %:% 
        foreach(r=1:nrow(pos), .combine = c) %do%
            seq.int(pos[r,1], pos[r,2])
    return(patterns.idx)
}

getColours <- function(patterns, palette){
    brewer.pal(length(patterns), palette)
}

colourCode <- function(seq, idx, colours){
    plot.colours <- rep("black", nchar(seq))
    
    for (i in 1:length(idx)){
        plot.colours[idx[[i]]] <- colours[i]
    }
    return(plot.colours)
}

getCoords <- function(seq, plotWidth){
    plotHeight <- ceiling(nchar(seq)/plotWidth)
    
    x <- rep_len(1:plotWidth, nchar(seq))
    y <- rep(plotHeight:1, each=plotWidth, length.out=nchar(seq))
    return(list(x,y))
}

makePlot <- function(seq, coords, colours){
    temp_df <- data.frame(x=coords[[1]], y = coords[[2]],
                          char=strsplit(seq, "")[[1]])
    print(ggplot(temp_df, aes(x=x,y=y, label=char)) + 
              geom_text(colour=colours) + 
              theme_bw())
}