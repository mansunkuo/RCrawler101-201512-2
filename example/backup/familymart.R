#' ---
#' title: "PTT Crawler Live Demo"
#' author: "Agilelearning"
#' date: "`r Sys.Date()`"
#' output: 
#'   html_document: 
#'     toc: yes
#' ---

library(httr)
library(jsonlite)

FM_TW_STORE <- data.frame()
addr_tw <- c("基隆市","台北市","新北市","桃園市","新竹市","新竹縣","苗栗縣","台中市","彰化縣","南投縣","雲林縣","嘉義市","嘉義縣","台南市","高雄市","屏東縣","宜蘭縣","花蓮縣","台東縣","澎湖縣","金門縣")

for(a in 1:length(addr_tw)) {
    addr <- URLencode(addr_tw[a])
    FM_URL = paste0("http://api.map.com.tw/net/familyShop.aspx?searchType=ShopList&type=&city=",addr,"&area=&road=&fun=showStoreList&key=6F30E8BF706D653965BDE302661D1241F8BE9EBC", collapse = "")
    
    FM_store <- GET(FM_URL, 
                    config=set_cookies('ServerName'='www%2Efamily%2Ecom%2Etw;',
                                       "ASPSESSIONIDSQDBRTSD"="PLBKNCAGIGAKILIPJALCPKK;",
                                       "ASP.NET_SessionId"="nnhplttz2ofmvfypfbsuyo0f"), 
                    add_headers("User-Agent" = "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.80 Safari/537.36",
                                "Referer" = "http://www.family.com.tw/marketing/inquiry.aspx",
                                "Host" = "api.map.com.tw",
                                "Connection" = "keep-alive",
                                "Accept-Language" = "zh-TW,zh;q=0.8,en-US;q=0.6,en;q=0.4",
                                "Accept-Encoding" = "gzip, deflate, sdch",
                                "Accept" = "*/*"))
    
    FM_store_list <- content(FM_store, type="text", encoding = "utf8")
    jsonDataString = sub("[^\\]]*$","",sub("^[^\\[]*","",FM_store_list))
    jsonData = fromJSON(jsonDataString)
    jsonData$city = addr_tw[a]
    FM_TW_STORE <- rbind(FM_TW_STORE, jsonData)
    t <- runif(1, 1.1, 5.5)
    Sys.sleep(t)
}

