#' ---
#' title: "CSS Demo1"
#' author: "Agilelearning, Mansun Kuo"
#' date: "`r Sys.Date()`"
#' ---

doc = "<html>
<head></head>
<body>
<div id='character1' class='character'>
<span class='name'>Mike</span>
<span class='level digit'>10</span>
</div>
<div id='character2' class='character'>
<span class='name'>Stan</span>
</div>
</body>
</html>"


#' ## rvest example
library(rvest)
doc1 = read_html(doc)
doc1

#' Names of the characters
doc1 %>% 
    html_nodes(css = ".character>.name") %>% 
    html_text()

#' Name of character1
doc1 %>% 
    html_nodes(css = "#character1>.name") %>% 
    html_text()


#' ## CSS example
library(XML)
library(CSS)
doc2 <- htmlParse(doc)
doc2

#' Names of the characters
doc2[cssToXpath(".character>.name")]
cssApply(doc2, ".character>.name", cssCharacter)

#' Name of character1
doc2[cssToXpath("#character1>.name")]
cssApply(doc2, "#character1>.name", cssCharacter)








