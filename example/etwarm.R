#' ---
#' title: "ETwarm"
#' author: "Agilelearning, Mansun Kuo"
#' date: "`r Sys.Date()`"
#' output: 
#'   html_document: 
#'     toc: yes
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
# for (i in 1:length(urls)) {
for (i in 1:3) {
    res = read_html(urls[i]) 
    district = res %>% 
        html_nodes(xpath = "//li[@class='obj_item']/div[@class='obj_info']/h3/a") %>% 
        html_text %>%
        iconv(from = "UTF-8", to = "UTF-8") %>% # to comparable in Wondows  
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

# Count number of element in each district
houses_agg = houses[, .(count = .N, 
                          mean_price = mean(price)), 
                      by = "district"]

# Add number of element in original data.table
head(apply(houses, 2, Encoding))
head(apply(houses_agg, 2, Encoding))

# Left join with data.table::merge
# both encoding are UTF-8 should be ok so we suppress warnings
houses_merge = suppressWarnings(
    merge(houses, houses_agg, 
          by.x = "district", by.y = "district",
          all.x = TRUE, all.y = FALSE)
)
houses_merge

