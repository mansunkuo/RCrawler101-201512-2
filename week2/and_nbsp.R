#' ---
#' title: "&nbsp"
#' author: "Agilelearning, Mansun Kuo"
#' date: "`r Sys.Date()`"
#' ---

library(XML)
library(httr)
library(stringr)


#' ## Invisible Character: &nbsp
URL <- 'http://www.appledaily.com.tw/appledaily/article/headline/20150614/36607699/%E5%9C%8B%E4%BA%8C%E7%94%B7%EF%BC%9A%E4%BD%A0%E6%AD%BB%E4%BA%86%E5%B9%B3%E6%9D%BF%E5%B0%B1%E6%88%91%E7%9A%84%E6%8E%A8%E5%90%8C%E5%AD%B8%E6%92%9E%E8%BB%8A%E6%98%8F%E8%BF%B7'
res <- content(GET(URL), encoding='utf8')
newsCate <- xpathSApply(res, '//label', xmlValue)[1]
newsCateTest<- gsub("頭條要聞|〉", "", newsCate)
charToRaw(newsCateTest)
gsub("\xc2\xa0", "", newsCateTest)


#' ## Remove &nbsp
URL <- 'http://www.appledaily.com.tw/appledaily/article/headline/20150614/36607699/%E5%9C%8B%E4%BA%8C%E7%94%B7%EF%BC%9A%E4%BD%A0%E6%AD%BB%E4%BA%86%E5%B9%B3%E6%9D%BF%E5%B0%B1%E6%88%91%E7%9A%84%E6%8E%A8%E5%90%8C%E5%AD%B8%E6%92%9E%E8%BB%8A%E6%98%8F%E8%BF%B7'
res <- content(GET(URL),'text', encoding='utf8')
res <- str_replace_all(res,'&nbsp', "_!_")
res <- htmlParse(res,encoding = 'utf8')
newsCate <- xpathSApply(res, '//label', xmlValue)[1]
gsub("_!_;〉", "", newsCate)

