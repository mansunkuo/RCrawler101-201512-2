#' ---
#' title: "Guestbook"
#' author: "Agilelearning, Mansun Kuo"
#' date: "`r Sys.Date()`"
#' output: 
#'   html_document: 
#'     toc: yes
#' ---

#+ include=FALSE
# set root dir when rendering
knitr::opts_knit$set(root.dir = '..')


#' [Guestbook](http://apt-bonbon-93413.appspot.com/)

library(httr)

post_url = "http://apt-bonbon-93413.appspot.com/sign"

#' Body can be a character
post_body = paste0("content=", URLencode("中午吃啥？"))
POST(post_url, body = post_body)

#' Or a named list 
post_body = list(content = sprintf("[TEST Posting Message] %s At %s", 
                                   "今天天氣很好", 
                                   Sys.time()))
POST(post_url, body = post_body)
