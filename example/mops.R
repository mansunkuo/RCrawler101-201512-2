#' ---
#' title: "公開資訊觀測站(Market Observation Post System)"
#' author: "Agilelearning, Mansun Kuo "
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
library(data.table)

#' ## Connector
# Use character body
url = "http://mops.twse.com.tw/mops/web/ajax_t51sb01"
res = POST(url, body = "encodeURIComponent=1&step=1&firstin=1&TYPEK=sii&code=")
doc_str = content(res, as = "text", encoding = "utf8")

# Use named list body
body = list(encodeURIComponent="1",
            step="1",
            firstin="1",
            TYPEK="sii",
            code="")
res2 = POST(url, body = body, encode = "form")
doc_str2 = content(res2, "text", encoding = "utf8")

#' ## Parser

if (.Platform$OS.type == "windows"){
    Sys.setlocale(category='LC_ALL', locale='C')
    dt = doc_str %>% 
        read_html(encoding = "big-5") %>% 
        html_nodes(xpath = "//table[2]") %>% 
        html_table(header=TRUE)
    Sys.setlocale(category='LC_ALL', locale='cht')
    dt = apply(dt[[1]],2,function(x) iconv(x,from = "utf8"))
    colnames(dt) = iconv(colnames(dt), from = "utf8")
} else{
    dt = doc_str %>% 
        read_html(encoding = "big-5") %>% 
        html_nodes(xpath = "//table[2]") %>% 
        html_table(header=TRUE)
    dt = dt[[1]]
}


#' ## Result
datatable(dt)


#' ## Check if identical

parse_table = function(doc_str, encoding = "big-5", xpath = "//table[2]") {
    dt = doc_str %>% 
        read_html(encoding = encoding) %>% 
        html_nodes(xpath = xpath) %>% 
        html_table(header=TRUE)
    dt = dt[[1]]
    return(dt)
}

if (.Platform$OS.type == "windows"){
    Sys.setlocale(category='LC_ALL', locale='C')
    print(identical(parse_table(doc_str), parse_table(doc_str2)))
    Sys.setlocale(category='LC_ALL', locale='cht')
} else{
    identical(parse_table(doc_str), parse_table(doc_str2))
}


#' ## Who is the key person

dt = data.table(dt)
positions = c("董事長", "總經理", "發言人")
heads = melt(dt, id.var = "公司名稱", measure.vars = positions,
             variable.name = "position", value.name = "person")
heads_count = heads[, .(count = .N), by = "person"][count > 1, ][order(-count), ]
heads_count = suppressWarnings(heads_count[!person %in% positions, ])
datatable(heads_count)
