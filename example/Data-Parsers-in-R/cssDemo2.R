#' ---
#' title: "CSS Demo1"
#' author: "Agilelearning, Mansun Kuo"
#' date: "`r Sys.Date()`"
#' ---

#' Sample Site: http://ecshweb.pchome.com.tw/search/v3.3/?q=sony 

doc <- '<dd class="c2f">
<b class="sp">24小時到貨</b>
<h5>
<a href="http://24h.pchome.com.tw/prod/DGALS8-A9005BTBS">
<em>SONY</em> Xperia M2 D2303
</a>
</h5>
<span>▼春電斬↘狂降$1000▼<em>SONY</em> Xperia M2 D2303 高速娛樂智慧機</span>
<ul class="clearfix" id="bookInfo"></ul>
</dd>'


#' ## rvest example
library(rvest)
doc1 = read_html(doc) %>% 
    html_nodes(css = "h5>a") %>% 
    html_text()
doc1


#' ## CSS example
library(XML) 
library(CSS)

doc2 = htmlParse(doc, encoding = "UTF-8")
doc2

doc2[cssToXpath("h5>a")]
cssApply(doc2, "h5>a", cssCharacter)
