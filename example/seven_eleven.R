#' ---
#' title: "Seven Eleven"
#' author: "Agilelearning"
#' date: "`r Sys.Date()`"
#' output: 
#'   html_document: 
#'     toc: yes
#' ---

#' [7-11](http://emap.pcsc.com.tw/)  

library(httr)
library(XML)
library(DT)

#' ## Get StoreData via POST city and town

# connector
res = POST("http://emap.pcsc.com.tw/EMapSDK.aspx",
           body=list(commandid="SearchStore",city="台北市",town="大安區"))

# parser
node = xmlParse(content(res,as="text"))
df = xmlToDataFrame(node["//GeoPosition"])
if (interactive()) {
    View(df)
} else {
    datatable(df)
}


#' ## Get Town via POST cityid

# connector
res = POST("http://emap.pcsc.com.tw/EMapSDK.aspx",
           body=list(commandid="GetTown",cityid="01"))

# parser
node = xmlParse(content(res,as="text"))
df = xmlToDataFrame(node["//GeoPosition"])
if (interactive()) {
    View(df)
} else {
    datatable(df)
}


#' ## Get CityCodes via POST cityid

res = GET("http://emap.pcsc.com.tw/lib/areacode.js")
resText = content(res,"text",encoding = "utf8")
matches = gregexpr("AreaNode[(][^,]+(,[^,]+){3}",resText)
unlist(regmatches(resText,matches))
cityCodesStr = unlist(regmatches(resText,matches))

string = cityCodesStr[2]
string
matches = gregexpr("[']([^']+)[']",string)
unlist(regmatches(string,matches))

cityCodes = lapply(cityCodesStr,function(string){
    matches = gregexpr("[']([^']+)[']",string)
    return(unlist(regmatches(string,matches)))
})

cityCodes = lapply(cityCodesStr[2:length(cityCodesStr)],function(string){
    matches = gregexpr("[']([^']+)[']",string)
    return(gsub("'","",unlist(regmatches(string,matches))))
})

cityCodesDf = data.frame(do.call(rbind,cityCodes),stringsAsFactors = FALSE)
colnames(cityCodesDf) = c("cityName","cityCode")
if (interactive()) {
    View(cityCodesDf)
} else {
    datatable(cityCodesDf)
}

