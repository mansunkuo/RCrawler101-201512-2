#' ---
#' title: "公開資訊觀測站(Market Observation Post System)"
#' author: "Agilelearning"
#' date: "`r Sys.Date()`"
#' output: 
#'   html_document: 
#'     toc: yes
#' ---

#+ include=FALSE
# set root dir when rendering
knitr::opts_knit$set(root.dir = '..')


#' [公開資訊觀測站](http://mops.twse.com.tw/mops/web/t51sb01)

library(httr)
library(rvest)
library(DT)

#' ## Connector
# Use character body
url = "http://mops.twse.com.tw/mops/web/ajax_t51sb01"
res = POST(url, body = "encodeURIComponent=1&step=1&firstin=1&TYPEK=sii&code=")
doc_str = content(res, "text", encoding = "utf8")

# Use named list body
body = list(encodeURIComponent="1",
            step="1",
            firstin="1",
            TYPEK="sii",
            code="")
res2 = POST(url, body = body, encode = "form")
doc_str2 = content(res, "text", encoding = "utf8")
identical(doc_str, doc_str2)
write(doc_str, file = "example/mops.html")

#' ## Parser
if (.Platform$OS.type == "windows"){
    Sys.setlocale(category='LC_ALL', locale='C')
    data_table = doc_str %>% read_html(encoding = "big-5") %>% html_nodes(xpath = "//table[2]") %>% html_table(header=TRUE)
    Sys.setlocale(category='LC_ALL', locale='cht')
    data_table = apply(data_table[[1]],2,function(x) iconv(x,from = "utf8"))
    colnames(data_table) = iconv(colnames(data_table), from = "utf8")
} else{
    data_table = doc_str %>% read_html(encoding = "big-5") %>% html_nodes(xpath = "//table[2]") %>% html_table(header=TRUE)
    data_table = data_table[[1]]
}

#' ## Result
datatable(data_table)
