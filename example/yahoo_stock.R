#' ---
#' title: "Seven Eleven"
#' author: "Agilelearning"
#' date: "`r Sys.Date()`"
#' output: 
#'   html_document: 
#'     toc: yes
#' ---

#+ include=FALSE
# set root dir when rendering
knitr::opts_knit$set(root.dir = '..')


#' [Yahoo Stock](http://tw.stock.yahoo.com/d/s/major_2451.html)

library(httr)
library(rvest)


## Connector
Target_URL = "http://tw.stock.yahoo.com/d/s/major_2451.html"
res <- GET(Target_URL)
doc_str <- content(res, type = "text", encoding = "big5")

## Parser
if (.Platform$OS.type == "windows"){
    Sys.setlocale(category='LC_ALL', locale='C')
    df <- doc_str %>% 
        read_html(encoding = "big-5") %>% 
        html_nodes(xpath = "//table[1]//table[2]") %>% 
        html_table(header=TRUE)
    Sys.setlocale(category='LC_ALL', locale='cht')
    df <- apply(df[[1]], 2, function(x) {iconv(x, from = "utf8")})
    colnames(df) <- iconv(colnames(df), from = "utf8")
}  else{
    df <- doc_str %>% read_html(encoding = "big-5") %>% html_nodes(xpath = "//table[1]//table[2]") %>% html_table(header=TRUE)
    df <- df[[1]]
}

if (interactive()) {
    View(df)
} else {
    library(DT)
    datatable(df)
}
