#' ---
#' title: "Seven Eleven"
#' author: "Agilelearning, Mansun Kuo"
#' date: "`r Sys.Date()`"
#' output: 
#'   html_document: 
#'     toc: yes
#' ---

#+ include=FALSE
# set root dir when rendering
knitr::opts_knit$set(root.dir = '..')


#' [7-11](http://emap.pcsc.com.tw/)  

library(httr)
library(XML)
library(stringr)
library(DT)
library(data.table)
suppressPackageStartupMessages(library(googleVis))
library(leaflet)


#' ## Get Stores

get_stores = function(city, town) {
    res = POST("http://emap.pcsc.com.tw/EMapSDK.aspx",
               body = list(commandid="SearchStore", 
                           city = city,
                           town = town))
    stores = xmlParse(content(res, as = "text")) %>% 
        .["//GeoPosition"] %>% 
        xmlToDataFrame %>% 
        data.table
    return(stores)
}

stores = get_stores("台北市", "大安區")
datatable(stores)


#' ## Get Towns

get_towns = function(cityid) {
    res = POST("http://emap.pcsc.com.tw/EMapSDK.aspx",
               body=list(commandid = "GetTown", cityid = cityid))
    towns = xmlParse(content(res, as = "text")) %>% 
        .["//GeoPosition"] %>% 
        xmlToDataFrame %>% 
        data.table
    return(towns)
}

towns = get_towns('01')
towns


#' ## Get Cities

res = GET("http://emap.pcsc.com.tw/lib/areacode.js")
res_text = content(res,"text",encoding = "utf8")
cityreg = "new AreaNode\\(\\'(.*)\\'.*new bu.* \\'(.*)\\'"
cities = res_text %>% 
    str_match_all(cityreg)%>% 
    .[[1]] %>% 
    .[, c(2, 3)] %>% 
    data.table()
setnames(cities, colnames(cities), c("cityname", "citycode"))
cities


#' ## Get All Stores

stores = list()
# for (i in 2:nrow(cities)) {
for (i in 2:2) {
    cityname = cities$cityname[i]
    citycode = cities$citycode[i]
    towns = get_towns(citycode)
    for (townname in towns$TownName) {
        stores[[paste0(cityname, townname)]] = get_stores(cityname, townname)
        citytown = paste0(cityname, townname)
        message(citytown)
        if (nrow(stores[[citytown]]) > 0 ) {
            stores[[citytown]]$cityname = cityname
            stores[[citytown]]$townname = townname   
        }
        Sys.sleep(abs(rnorm(1, 0)))
    }
}
stores = rbindlist(stores)

#' ## Draw a Map

# Convert unit of lat and lon
stores[, c("X", "Y") := lapply(.SD, 
                               function(x) {
                                   as.numeric(as.character(x))*10^(-6)
                               }),
       .SDcols = c("X", "Y")]

# prepare some meta information
stores[, `:=`(latlon = paste0(Y, ":", X),
              tips = sprintf("<p>%s</p><p>%s</p><p>%s</p>",
                             POIName, Telno, Address)
              )]

#' ### leaflet

leaflet(data = stores, height = 600, width = "auto") %>% 
    addTiles() %>%
    addMarkers(~X, ~Y, popup = ~as.character(tips),
               icon = list(iconUrl = "img/pc_logo.gif",
                           iconSize = c(20, 20)))

#' ### gvisMap
gmap = gvisMap(stores, "latlon", "tips",
               options=list(showTip=TRUE, 
                            enableScrollWheel=T,
                            height=600,
                            useMapTypeControl=T,
                            mapType='normal'
               )
)

#+ results='asis'
if (interactive()) {
    if (.Platform$OS.type == "windows") {
        gmap$html$header = gsub("utf-8", "Big5", gmap$html$header)
    }
    plot(gmap)
} 
print(gmap, "chart")
    

