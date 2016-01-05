# RCrawler101-201512-2

A tutorial of Crawler in R.

[slides](http://mansunkuo.github.io/RCrawler101-201512-2/)


## Environment

### R

#### Windows

Download and install R base and Rtools.

- https://cran.rstudio.com/bin/windows/base/
- https://cran.rstudio.com/bin/windows/Rtools/

#### Mac

Download R-x.x.x.pkg and install it.

- https://cran.r-project.org/bin/macosx/

#### Linux

- [Ubuntu](https://cran.r-project.org/bin/linux/ubuntu/README.html)
- [Red Hat](https://cran.r-project.org/bin/linux/redhat/README)

You may need install some system libraries for our R packages.
Here we only take Ubuntu as example.

Curl:

```bash
sudo apt-get install curl libcurl4-openssl-dev
```

XML:
```bash
sudo apt-get install libxml2-dev
```

### RStudio

Download and install RStudio desktop.

- https://www.rstudio.com/products/rstudio/download/


### Packages

Open R console and execute following code:

```r
pkgs = c("httr", "rvest", "DT", "rmarkdown", "XML", "whisker", 
         "jsonlite", "magrittr", "data.table", "RSQLite", "knitr")
install.packages(pkgs)
```
