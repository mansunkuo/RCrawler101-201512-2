#' ---
#' title: "公開資訊觀測站(Market Observation Post System)"
#' author: "Agilelearning"
#' date: "`r Sys.Date()`"
#' output: 
#'   html_document: 
#'     toc: yes
#' ---

#' [公開資訊觀測站](http://mops.twse.com.tw/mops/web/t51sb01)

library(httr)
library(rvest)

## Connector

res <- POST("http://mops.twse.com.tw/mops/web/ajax_t51sb01",body = "encodeURIComponent=1&step=1&firstin=1&TYPEK=sii&code=")
doc_str <- content(res, "text", encoding = "utf8")
write(doc_str, file = "mops.html")

## Parser
if (.Platform$OS.type == "windows"){
    Sys.setlocale(category='LC_ALL', locale='C')
    data_table <- doc_str %>% read_html(encoding = "big-5") %>% html_nodes(xpath = "//table[2]") %>% html_table(header=TRUE)
    Sys.setlocale(category='LC_ALL', locale='cht')
    data_table <- apply(data_table[[1]],2,function(x) iconv(x,from = "utf8"))
    colnames(data_table) <- iconv(colnames(data_table), from = "utf8")
}  else{
    data_table <- doc_str %>% read_html(encoding = "big-5") %>% html_nodes(xpath = "//table[2]") %>% html_table(header=TRUE)
    data_table <- data_table[[1]]
}