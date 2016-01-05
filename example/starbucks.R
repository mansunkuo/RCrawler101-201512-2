#' ---
#' title: "Starbucks"
#' author: "Agilelearning, Mansun Kuo"
#' date: "`r Sys.Date()`"
#' output: 
#'   html_document: 
#'     toc: yes
#' ---

#+ include=FALSE
# set root dir when rendering
knitr::opts_knit$set(root.dir = '..')

#' [Starbucks](http://www.starbucks.com.tw/stores/storesearch/stores_storesearch.jspx)


library(httr)
library(XML)
library(rvest)
library(jsonlite)

#' ## Region

url = "http://www.starbucks.com.tw/store/region.serx"
body = "cid=11"
header = c(
    #"Accept" = "*/*",
    # "Accept-Encoding" = "gzip, deflate",
    # "Accept-Language" = "zh-TW,zh;q=0.8,en-US;q=0.6,en;q=0.4,zh-CN;q=0.2",
    # "Connection" = "keep-alive",
    # "Content-Length" = 6,
    "Content-Type" = "application/x-www-form-urlencoded"#,
    # "Cookie" = "JSESSIONID=E79E971BEEB5FE5A54A41A51A2EDC71C; citrix_ns_id=gOyZ2AnJ6WsydtGrLTgjpUCGJHIA020; citrix_ns_id_.starbucks.com.tw_%2F_wat=SlNFU1NJT05JRF9f?KCaPwF2HVIKd4ibm6ixR88jzDOEA&; _gat=1; _ga=GA1.3.1117139448.1446024192",
    # "Host" = "www.starbucks.com.tw",
    # "Origin" = "http://www.starbucks.com.tw",
    # "Referer" = "http://www.starbucks.com.tw/stores/storesearch/stores_storesearch.jspx",
    # "User-Agent" = "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36",
    # "X-Requested-With" = "XMLHttpRequest"
)
res = POST(url, body = body, add_headers(header))
result = content(res, as = "text")
regions = fromJSON(result)
str(regions)
regions$region[[1]]



#' ## Store 

url = "http://www.starbucks.com.tw/stores/storesearch/stores_storesearch.jspx"
body = upload_file("data/starbucks.txt")
header = c(
    # "Accept" = "*/*",
    # "Accept-Encoding" = "gzip, deflate",
    # "Accept-Language" = "zh-TW,zh;q=0.8,en-US;q=0.6,en;q=0.4,zh-CN;q=0.2",
    # "Connection" = "keep-alive",
    # "Content-Length" = 29110, 
    "Content-Type" = "application/x-www-form-urlencoded; charset=UTF-8"#,
    # "Cookie" = "citrix_ns_id=xRVZEEJoDMo7memBaPa/NnRypKIA020; JSESSIONID=F9408BEF289C374601018E306A7E870C; citrix_ns_id_.starbucks.com.tw_%2F_wat=SlNFU1NJT05JRF9f?U8jwSOlGNbieBO9tjD53BlNQP8EA&; _ga=GA1.3.1117139448.1446024192",
    # "Host" = "www.starbucks.com.tw",
    # "Origin" = "http://www.starbucks.com.tw",
    # "Referer" = "http://www.starbucks.com.tw/stores/storesearch/stores_storesearch.jspx",
    # "User-Agent" = "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36"
)
res = POST(url, body = body, add_headers(header))

# Save as raw
bin = content(res, as = "raw")
writeBin(bin, "example/starbucks_stores.html")

# Extract stories
result = content(res, as = "text")
read_html(result, encoding = "utf-8") %>% 
    html_nodes(xpath = "//div[@class='searchstore_name']") %>% 
    iconv(from = "UTF-8", to = "UTF-8") # solve encoding issue in Windows

# XML
htmlParse(res, encoding = 'utf8') %>% 
    xpathSApply("//div[@class='searchstore_name']", xmlValue)

