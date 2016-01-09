#' ---
#' title: "Yahoo Stock"
#' author: "Agilelearning, Mansun Kuo"
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
library(DT)


#' ## Connector
Target_URL = "http://tw.stock.yahoo.com/d/s/major_2451.html"
res = GET(Target_URL)

#' ## Parser Solution 1

# read as raw
doc_str = content(res, type = "raw")

## Parser
if (.Platform$OS.type == "windows"){
    Sys.setlocale(category='LC_ALL', locale='C')
    dat = doc_str %>% 
        read_html() %>% 
        html_nodes(xpath = "//table[1]//table[2]") %>% 
        html_table(header=TRUE)
    Sys.setlocale(category='LC_ALL', locale='cht')
    dat = dat[[1]]
    dat = apply(dat, 2, function(x) {iconv(x, from = "utf8")})
    colnames(dat) = iconv(colnames(dat), from = "utf8")
}  else{
    dat = doc_str %>% 
        read_html() %>% 
        html_nodes(xpath = "//table[1]//table[2]") %>% 
        html_table(header=TRUE)
    dat = dat[[1]]
}


#' ## Parser Solution 2

# check content-type
headers(res)$`content-type`

# read as Big5
doc_str2 = content(res, type = "text", encoding = "Big5")

## Parser
if (.Platform$OS.type == "windows"){
    Sys.setlocale(category='LC_ALL', locale='C')
    dat2 = doc_str2 %>% 
        read_html(encoding = "Big5") %>% 
        html_nodes(xpath = "//table[1]//table[2]") %>% 
        html_table(header=TRUE)
    Sys.setlocale(category='LC_ALL', locale='cht')
    dat2 = dat2[[1]]
    dat2 = apply(dat2, 2, function(x) {iconv(x, from = "utf8")})
    colnames(dat2) = iconv(colnames(dat2), from = "utf8")
}  else{
    dat2 = doc_str %>% 
        read_html(encoding = "big-5") %>%
        html_nodes(xpath = "//table[1]//table[2]") %>% 
        html_table(header=TRUE)
    dat2 = dat2[[1]]
}

identical(dat, dat2)
datatable(dat)

