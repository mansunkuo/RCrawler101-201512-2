examples = list.files("example", pattern = ".*\\.R", full.names = TRUE)
for (example in examples) {
    message(example)
    source(example, encoding = "UTF-8")
    ls_all = ls()
    index = ! ls_all %in% c("examples", "example")
    rm(list = ls_all[index])
}
