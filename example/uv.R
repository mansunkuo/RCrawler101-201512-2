#' ---
#' title: "紫外線即時監測資料"
#' author: "Agilelearning, Mansun Kuo"
#' date: "`r Sys.Date()`"
#' output: 
#'   html_document: 
#'     toc: yes
#' ---

library(httr)
library(rvest)
library(jsonlite)

res = GET("http://opendata.epa.gov.tw/webapi/api/rest/datastore/355000000I-000004/?format=json")
result = res %>% 
    content(as = "text") %>%
    fromJSON()
str(result)
result$result$records
