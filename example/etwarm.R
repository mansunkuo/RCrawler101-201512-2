#' ---
#' title: "ETwarm"
#' author: "Agilelearning, Mansun Kuo"
#' date: "`r Sys.Date()`"
#' ---

library(httr)
library(rvest)
library(stringr)
library(data.table)

city = "台北市"
url = sprintf("http://www.etwarm.com.tw/object_list.php?city=%s", 
              URLencode(city))
max_index = 
    read_html(url) %>% 
    html_nodes(xpath = "//div[@class='page']/a") %>%
    html_text %>%
    str_extract("[0-9]+") %>%
    as.integer %>% 
    max(na.rm = TRUE)

urls = sprintf("http://www.etwarm.com.tw/object_list?city=%s&page=",
               URLencode(city))
urls = paste0(urls, 1:max_index)

houses = data.table()
for (i in 1:3) {
# for (i in 1:length(urls)) {
    res = read_html(urls[i]) 
    district = res %>% 
        html_nodes(xpath = "//li[@class='obj_item']/div[@class='obj_info']/h3/a") %>% 
        html_text %>% 
        str_extract(sprintf("%s.*區", city))
    price = res %>% 
        html_nodes(xpath = "//div[@class='price']") %>% 
        html_text %>% 
        str_replace_all(",", "") %>% 
        as.numeric()
    temp = data.table(district = district,
                      price = price)  
    houses = rbind(houses, temp)
    Sys.sleep(abs(rnorm(1)))
    print(urls[i])
}

houses[, .(count = .N), by = "district"]

houses[, count := .N, by = "district"]
houses


