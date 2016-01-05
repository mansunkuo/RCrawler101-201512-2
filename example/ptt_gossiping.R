#' ---
#' title: "PTT Gossiping"
#' author: "Agilelearning, Mansun Kuo"
#' date: "`r Sys.Date()`"
#' output: 
#'   html_document: 
#'     toc: yes
#' ---

#+ include=FALSE
# set root dir when rendering
knitr::opts_knit$set(root.dir = '..')


#' [PTT Gossiping](https://www.ptt.cc/bbs/Gossiping/index.html)
#'

#' ## rvest example
#'

#' ### Get links of index pages

library(rvest)
library(httr)
library(stringr)
url = "https://www.ptt.cc/bbs/Gossiping/index.html"
res = GET(url, config=set_cookies('over18'='1')) %>% 
    content(as = "text") %>% 
    read_html(res)

res_href = res %>% 
    html_nodes(xpath = '//*[@id="action-bar-container"]/div/div[2]/a[2]') %>% 
    html_attr("href")
res_href

tmpIndex = res_href %>% 
    str_extract('[0-9]+') %>% 
    (function(x){as.numeric(x)+1})
(tmpIndex-10):tmpIndex

sprintf("https://www.ptt.cc/bbs/Gossiping/index%s.html",(tmpIndex-10):tmpIndex)


#' ### Crawler example 
url = "https://www.ptt.cc/bbs/Gossiping/M.1434384024.A.711.html"
res = GET(url, config=set_cookies('over18'='1')) %>% 
    read_html(res, encoding = "UTF-8") %>% 
    html_nodes(xpath = '//*[@id="main-content"]/div/span[1]')
res
res_text = res %>% 
    html_nodes(xpath = '//*[@id="main-content"]/div/span[1]') %>% 
    html_text() %>%  
    iconv(from = "UTF-8", to = "UTF-8") 
head(res_text[!str_detect(res_text, '作者|看板|標題|時間')])



#' ## XML example
library(httr)
library(XML)
library(stringr)


#' ### Get links of index pages
url <- "https://www.ptt.cc/bbs/Gossiping/index.html"
res <- GET(url, config=set_cookies('over18'='1'))
res <- content(res, 'text', encoding = 'utf8')
res <- htmlParse(res, encoding = 'utf8')
tmpIndex <-xpathSApply(res, '//*[@id="action-bar-container"]/div/div[2]/a[2]', xmlAttrs)
tmpIndex <-tmpIndex["href",]
tmpIndex <- str_extract(tmpIndex, '[0-9]+')
tmpIndex <- as.numeric(tmpIndex)+1

(tmpIndex-10):tmpIndex

sprintf("https://www.ptt.cc/bbs/Gossiping/index%s.html",(tmpIndex-10):tmpIndex)


#' ### Crawler example 
# url <- "https://www.ptt.cc/bbs/Gossiping/M.1431338763.A.1BF.html"
url <- "https://www.ptt.cc/bbs/Gossiping/M.1434384024.A.711.html"
res <- GET(url, config=set_cookies('over18'='1'))
res <- content(res, 'text', encoding = 'utf8')
res <- htmlParse(res, encoding = 'utf8')
push <-xpathSApply(res, '//*[@id="main-content"]/div/span[1]', xmlValue)
head(push[!str_detect(push, '作者|看板|標題|時間')])

