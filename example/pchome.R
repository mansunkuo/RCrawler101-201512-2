#' ---
#' title: "PChome"
#' author: "Agilelearning, Mansun Kuo"
#' date: "`r Sys.Date()`"
#' output: 
#'   html_document: 
#'     toc: yes
#' ---

#' [PCHome](http://ecshweb.pchome.com.tw/search/v3.3/)

library(DBI)
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

#' Create an ephemeral in-memory RSQLite database
# con = dbConnect(SQLite(), ":memory:")
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
if (interactive()) {
    print(pchome)
} else {
    datatable(pchome)
}

#' You can fetch results with SQL statement
res = dbSendQuery(con, "SELECT * FROM pchome WHERE price > 10000")
pchome = dbFetch(res)
str(pchome)
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
