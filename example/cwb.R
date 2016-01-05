#' ---
#' title: "CWB"
#' author: "Mansun Kuo"
#' date: "`r Sys.Date()`"
#' output: 
#'   html_document: 
#'     toc: yes
#' ---

#+ include=FALSE
# set root dir when rendering
knitr::opts_knit$set(root.dir = '..')


#' [觀測資料查詢系統](http://e-service.cwb.gov.tw/HistoryDataQuery/)


library(XML)
library(whisker)
library(data.table)
stations = list(Taipei = "466920", 
                Taichung = "467490",
                Kaohsiung = "467440",
                Hualien = "466990"
)
datestart = "2015-11-01"
dateend = "2015-11-01"
crawler_type = "daily"
en = TRUE


get_data = function(stations, 
                    datestart = "2015-01-01",
                    dateend = "2015-01-01",
                    crawler_type = "daily",
                    en = TRUE,
                    max_error_time = 3) {
    dir.create(sprintf("data/%s", crawler_type), 
               showWarnings = FALSE, recursive = TRUE)
    if (crawler_type == "monthly") {
        datetimes = substr(as.character(seq.Date(as.Date(datestart), as.Date(dateend), by="months")), 1, 7)
        tempurl = "http://e-service.cwb.gov.tw/HistoryDataQuery/MonthDataController.do?command=viewMain&station={{station}}&datepicker={{datetime}}"
        header_expr = "^[^A-Z]*|A型蒸發量\\.mm\\.|X10分鐘最大降水量|\\.mm\\.|X10分鐘最大降水起始時間|(\\.)*LST(\\.)*|MJ\\.*|Pa\\.*"
    } else if (crawler_type == "daily") {
        datetimes = substr(as.character(seq.Date(as.Date(datestart), as.Date(dateend), by="day")), 1, 10)
        tempurl = "http://e-service.cwb.gov.tw/HistoryDataQuery/DayDataController.do?command=viewMain&station={{station}}&datepicker={{datetime}}"
        header_expr = "^[^A-Z]*|.*\\)|( )*"
    }
    
    for (i in 1:length(stations)) {
        dts = list()
        station_name = names(stations[i])
        station = stations[[i]]
        for (datetime in datetimes) {
            tryCatch({
                error_time = 0
                get_table(station, station_name, datetime, crawler_type, en, 
                          header_expr, tempurl)
            }, error = function(e) {
                error_time = error_time + 1
                if (error_time <= max_error_time) {
                    get_table(station, station_name, datetime, crawler_type, en, 
                              header_expr, tempurl)
                }
            })
            
        }
    }
}

get_table = function(station, station_name, datetime, crawler_type, en, 
                     header_expr, tempurl) {
    url = whisker.render(tempurl, 
                         list(station = station, 
                              datetime = datetime))
    print(url)
    tables = readHTMLTable(url, encoding="UTF-8", stringsAsFactor = FALSE)
    
    sleeptime = rpois(1, 1) + runif(1, 0.5, 1.5)
    print(sleeptime)
    Sys.sleep(sleeptime)
    
    temptable = tables$MyTable
    colnames(temptable) = as.vector(as.matrix(temptable[2,]))
    temptable = temptable[3:nrow(temptable), ]
    filename = whisker.render("data/{{crawler_type}}/{{station_name}}_{{datetime}}.csv",
                              list(crawler_type = crawler_type, 
                                   station_name = station_name, 
                                   datetime = datetime))
    print(filename)
    
    if (en) {
        header_all = colnames(temptable)
        header_en = gsub(header_expr, "", header_all)
        colnames(temptable) = header_en
    }
    write.csv(temptable, filename, row.names = FALSE)
}


get_data(stations, datestart = datestart, dateend = dateend)

