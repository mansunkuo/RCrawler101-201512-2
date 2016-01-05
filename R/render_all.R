#!/usr/bin/env Rscript
library(rmarkdown)

examples = list.files("example", pattern = ".*\\.R", full.names = TRUE)
for (example in examples) {
    render(example)
}
