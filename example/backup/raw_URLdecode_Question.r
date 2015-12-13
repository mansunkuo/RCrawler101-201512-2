##################################
#     raw URLdecode Question     #
##################################
rm(list=ls())
R.version.string
# [1] "R version 3.1.3 (2015-03-09)"

charToRaw(":") # [1] 3a
charToRaw("/") # [1] 2f
charToRaw(" ") # [1] 20
charToRaw('"') # [1] 22

## example chinatimes news 
URL <- 'http://www.chinatimes.com/newspapers/20150701000417-260102'

URLreq <-'http://graph.facebook.com/fql?q=SELECT%20url,%20normalized_url,%20share_count,%20like_count,%20comment_count,%20total_count,commentsbox_count,%20comments_fbid,%20click_count%20FROM%20link_stat%20WHERE%20url=%22http%3A%2F%2Fwww.chinatimes.com%2Fnewspapers%2F20150701000417-260102%22&callback=_ate.cbs.rcb_httpwwwchinatimescom3'
URLdecode(URLreq)

qParamater <- 'SELECT%20url,%20normalized_url,%20share_count,%20like_count,%20comment_count,%20total_count,commentsbox_count,%20comments_fbid,%20click_count%20FROM%20link_stat%20WHERE%20url=%22http%3A%2F%2Fwww.chinatimes.com%2Fnewspapers%2F20150701000417-260102%22'

# Query String Parameters 
# q:SELECT url, normalized_url, share_count, like_count, comment_count, total_count,commentsbox_count, comments_fbid, click_count FROM link_stat WHERE url="http://www.chinatimes.com/newspapers/20150701000417-260102"
# callback:_ate.cbs.rcb_httpwwwchinatimescom3

q <- 'SELECT url, normalized_url, share_count, like_count, comment_count, total_count,commentsbox_count, comments_fbid, click_count FROM link_stat WHERE url="http://www.chinatimes.com/newspapers/20150701000417-260102"'
URLencode(q)
#        [1] "SELECT%20url,%20normalized_url,%20share_count,%20like_count,%20comment_count,%20total_count,commentsbox_count,%20comments_fbid,%20click_count%20FROM%20link_stat%20WHERE%20url=%22http://www.chinatimes.com/newspapers/20150701000417-260102%22"
# qParamater 'SELECT%20url,%20normalized_url,%20share_count,%20like_count,%20comment_count,%20total_count,commentsbox_count,%20comments_fbid,%20click_count%20FROM%20link_stat%20WHERE%20url=%22http%3A%2F%2Fwww.chinatimes.com%2Fnewspapers%2F20150701000417-260102%22'


URLreplace  <- str_replace_all(str_replace_all(URL, '/', '%2F'), ':' ,'%3A')
URLreplace2 <- gsub(':' ,'%3A', gsub('/', '%2F', URL ))
URLreplace==URLreplace2
# [1] TRUE

URLreplace
# [1] "http%3A%2F%2Fwww.chinatimes.com%2Fnewspapers%2F20150701000417-260102"
qParamterCreate <- paste0('http://graph.facebook.com/fql?q=SELECT%20url,%20normalized_url,%20share_count,%20like_count,%20comment_count,%20total_count,commentsbox_count,%20comments_fbid,%20click_count%20FROM%20link_stat%20WHERE%20url=%22', 
                          URLreplace, 
                          '%22', 
                          '&callback=_ate.cbs.rcb_httpwwwchinatimescom3')
URLreq==qParamterCreate
# [1] TRUE

URLdecode(qParamterCreate)
