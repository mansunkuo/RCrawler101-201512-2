library(httr)
library(XML)
library(CSS)
library(stringr)
library(rjson)
rm(list=ls())

# want data URL
'http://www.giantcyclingworld.com/web/store.php'

URL <- 'http://www.giantcyclingworld.com/web/ajax_store.php'
res <- POST(URL, body=list(act='store_name_search'))
resText <- content(res,'text')
wantData <- fromJSON(resText)$content
wantDataParse <- htmlParse(wantData, encoding = 'utf8')

wantDataTp <- xpathSApply(wantDataParse, '//ol/li/dl/dd', xmlValue)
result <- matrix(wantDataTp, ncol=4, byrow=TRUE)
result <- as.data.frame(result, stringsAsFactors=FALSE)
names(result) <- c('store', 'addr', 'tel_no', 'email')
result$store <- xpathSApply(wantDataParse, '//ol/li/dl/dt/a', xmlValue)

result$addr <- str_replace_all(result$addr, '(^[0-9])|:| |-','')
result$tel_no <- str_replace_all(result$tel_no, 'TEL|:| |-','')
result$email <- str_replace_all(result$email, 'MAIL|:| |-','')
View(result)

library(RSQLite) 
library(tmcn)
db = dbConnect(SQLite(), dbname="giantcyc.sqlite") 
dbWriteTable(db, "giantcyc", result) 
# dbSendQuery(db, ‘SQL_Query') 
dbListTables(db) 
giantcyc2 = dbGetQuery(db,  
                       "select * from giantcyc") 
giantcyc2 = sapply(giantcyc2, toUTF8) 
dbDisconnect(db) #  關閉 db 連結  
