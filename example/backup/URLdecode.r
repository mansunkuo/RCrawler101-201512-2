library(httr)
library(XML)
library(tmcn)
library(CSS)
library(stringr)
rm(list=ls())

##################################
#           connector            #
##################################
req <- GET("https://tw.news.yahoo.com/sports/")
reqText <- content(req, 'text', encoding = 'utf8')
reqParse <- htmlParse(reqText, encoding = 'utf8') # 注意encoding
# If encoding of html is big5, please use below code
# reqText <- content(req, 'text', encoding = 'big5')
# reqText <- toUTF8(reqText)
# reqParse <- htmlParse(reqText, encoding = 'utf8')

reqParse2 <- htmlParse(req)

req <- content(req)

##################################
#             parser             #
##################################

########### (1) get path by XPath 
# copy XPath, 如果有 tbody 請去掉
xpathSApply(req, '//*[@id="mediablistmixedlpcatemp"]/div/ul/li[1]/div/a', xmlAttrs)
# 抓值
xpathSApply(req, '//*[@id="mediablistmixedlpcatemp"]/div/ul/li[1]/div/a', xmlValue)
xpathSApply(req, '//*[@id="mediablistmixedlpcatemp"]/div/ul/li[1]/div', xmlValue)

# run it!  Test it work
xpathSApply(reqParse, '//*[@id="mediablistmixedlpcatemp"]/div/ul/li[1]/div/a', xmlAttrs)
xpathSApply(reqParse2, '//*[@id="mediablistmixedlpcatemp"]/div/ul/li[1]/div/a', xmlAttrs)

# delete "[1]"
resultXpath <- xpathSApply(req, '//*[@id="mediablistmixedlpcatemp"]/div/ul/li/div/a', xmlAttrs)

# 選出 href
(resultXpath <- resultXpath['href',])
# 有時候選擇到的元素屬性個數不同時, 會回傳list
xmlAttrsList <- list()
xmlAttrsList[[1]] <- c('href'='https://tw.yahoo.com/', 'id'='yahoo')
xmlAttrsList[[2]] <- c('href'='https://www.google.com.tw/')
xmlAttrsList
sapply(xmlAttrsList, function(x) x[names(x)=='href'])

# 轉 UTF8 ( OS: windows )
(resultXpath <- toUTF8(resultXpath))

resultXpath <- sapply(resultXpath, URLencode)
# 觀察真實網址得知 以下作法
resultXpath <- sprintf('https://tw.news.yahoo.com%s', resultXpath)
resultXpath <- paste0('https://tw.news.yahoo.com', resultXpath)
paste(c('https://tw.news.yahoo.com', resultXpath[1]), collapse='')

# check URL which you create is correct
resultXpath[1]


###########  (2) get path by css path  

# copy css path
cssApply(req, '#yui_3_9_1_1_1436632496712_1092', cssLink) 


# method1 : transform from Xpath => [數字] => 不轉
# method2 : look by html  
cssPath <- '#mediablistmixedlpcatemp > div > ul > li > div > a'
cssToXpath(cssPath)
resultCSS <- cssApply(req, cssPath, cssLink)
## R的特殊作法 但不建議 
xpathSApply(req, '//*[@id="mediablistmixedlpcatemp"]/div/ul/li[1]/div/a', cssLink)

# 抓值
cssApply(req, cssPath, cssCharacter)

# 轉 UTF8 ( OS: windows )
(resultCSS <- toUTF8(resultCSS))


resultCSS <- sapply(resultCSS, URLencode)
resultCSS <- paste0('https://tw.news.yahoo.com', resultCSS)
# check URL which you create is correct
resultCSS[1]


#### 抓內文
i=1
req <- GET(resultCSS[i])
req <- content(req)

newsText <- xpathSApply(req, '//*[@id="mediaarticlebody"]/div//p', xmlValue)
newsText <- paste(newsText, collapse = '')
newsTitle <- xpathSApply(req, '//h1', xmlValue)
resultTp <- data.frame(newsText=newsText, newsTitle=newsTitle, stringsAsFactors = FALSE)
View(resultTp)

# 寫成迴圈

resultNews <- list()
for(i in 1:length(resultCSS)){
    req <- GET(resultCSS[i])
    req <- content(req)
    newsText <- xpathSApply(req, '//*[@id="mediaarticlebody"]/div//p', xmlValue)
    newsText <- paste(newsText, collapse = '')
    newsTitle <- xpathSApply(req, '//h1', xmlValue)
    resultNews[[i]] <- data.frame(newsText=newsText, newsTitle=newsTitle, stringsAsFactors = FALSE)
}
resultNews2 <- do.call(rbind, resultNews)
View(resultNews2)


# what is do.call(rbind, resultNews)
View(rbind(resultNews[[1]], resultNews[[2]]))
View(rbind(resultNews[[1]], resultNews[[2]], resultNews[[3]]))
View(rbind(resultNews[[1]], resultNews[[2]], resultNews[[3]], resultNews[[4]]))




# os : windows
library(tmcn)
a <- '編碼問題'
iconv(a, 'big5', 'utf8')
URLencode(a)
URLencode(iconv(a, 'big5', 'utf8'))

res <- 'https://tw.news.yahoo.com/%E6%89%93%E5%87%BA%E8%B6%85%E5%89%8D%E5%88%86-%E8%91%A3%E5%AD%90%E6%81%A9%E7%AB%8B%E5%8A%9F-215007125.html'
toUTF8(URLdecode(res))


