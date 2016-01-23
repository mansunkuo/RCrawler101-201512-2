#' ---
#' title: "東森房屋"
#' author: "Agilelearning, Mansun Kuo"
#' date: "`r Sys.Date()`"
#' output: 
#'   html_document: 
#'     toc: yes
#' ---

#+ include=FALSE
# set root dir when rendering
knitr::opts_knit$set(root.dir = '..')


#' [東森房屋](http://www.etwarm.com.tw/object_list)

#'
#' ## Crawler

library(httr)
library(rvest)
library(stringr)
library(data.table)

city = "台北市"
# city = "新北市"
url = sprintf("http://www.etwarm.com.tw/object_list.php?area=%s", URLencode(city))

# Get the max index
max_index = read_html(url) %>% 
    html_nodes(xpath = "//div[@class='page']/a") %>%
    html_text %>%
    str_extract("[0-9]+") %>%
    as.integer %>% 
    max(na.rm = TRUE)

# Construct all urls
urls = sprintf("http://www.etwarm.com.tw/object_list?area=%s&page=", URLencode(city))
urls = paste0(urls, 1:max_index)

# Get data
houses = data.table()
# for (i in 1:length(urls)) {
for (i in 1:3) {
    res = read_html(urls[i]) 
    district = res %>% 
        html_nodes(xpath = "//li[@class='obj_item']/div[@class='obj_info']/h3/a") %>% 
        html_text %>%
        iconv(from = "UTF-8", to = "UTF-8") %>% # to compatible in Wondows  
        str_match(sprintf(".+(%s.*區)", city)) %>% 
        .[,2]
    price = res %>%  
        html_nodes(xpath = "//div[@class='price']") %>% 
        html_text %>% 
        str_replace_all(",", "") %>% 
        as.numeric()
    temp = data.table(district = district,
                      price = price)  
    houses = rbind(houses, temp)
    # Sys.sleep(abs(rnorm(1)))
    print(urls[i])
}
houses

#' ## Play with data.table

# Count number of element and mean price in each district
houses_agg = houses[, .(count = .N, 
                        mean_price = mean(price)), 
                    by = "district"]
houses_agg

# Encoding in our data.table
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

