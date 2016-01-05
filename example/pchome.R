#' ---
#' title: "PChome"
#' author: "Agilelearning, Mansun Kuo"
#' date: "`r Sys.Date()`"
#' output: 
#'   html_document: 
#'     toc: yes
#' ---

#+ include=FALSE
# set root dir when rendering
knitr::opts_knit$set(root.dir = '..')


#' [PCHome](http://ecshweb.pchome.com.tw/search/v3.3/)

library(RSQLite)
library(jsonlite)
library(httr)
library(magrittr)
library(DT)

url = "http://ecshweb.pchome.com.tw/search/v3.3/all/results?q=sony&page=1&sort=rnk/dc"
res_df = GET(url) %>% 
    content(as = "text") %>% 
    fromJSON() %>% 
    .$prods     # equivelent to (function(x) {x$prods})

#' Create a RSQLite database
con = dbConnect(SQLite(), "data/pchome.sqlite")

dbListTables(con)

#' Drop table if exist
if (dbExistsTable(con, "pchome")) {
    dbRemoveTable(con, "pchome")
}

#' Write data.frame to table
dbWriteTable(con, "pchome", res_df)

#' List tables
dbListTables(con)

#' List fields of a table
dbListFields(con, "pchome")

#' Read Whole Table
pchome = dbReadTable(con, "pchome")

# solve encoding issue in Windows
if (.Platform$OS.type == "windows"){
    pchome = apply(pchome, 2, iconv, from = "UTF-8", to = "UTF-8")
}

# if (interactive()) {
# print(pchome)
# } else {
datatable(pchome)
# }

#' You can fetch results with SQL statement
res = dbSendQuery(con, "SELECT * FROM pchome WHERE price > 10000")
pchome2 = dbFetch(res)
if (.Platform$OS.type == "windows"){
    pchome2 = apply(pchome2, 2, iconv, from = "UTF-8", to = "UTF-8")
}
str(pchome2)
dbClearResult(res)

#' Or a chunk at a time
res = dbSendQuery(con, "SELECT * FROM pchome WHERE price > 10000")
while(!dbHasCompleted(res)){
    chunk = dbFetch(res, n = 5)
    print(nrow(chunk))
}
#' Clear the result
dbClearResult(res)

#' Disconnect from the database
dbDisconnect(con)
