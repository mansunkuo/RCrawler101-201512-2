

# install.packages("tmcn", repos="http://R-Forge.R-project.org")
dir_name = "package"
dir.create(dir_name, showWarnings = FALSE)
urls = c("http://download.r-forge.r-project.org/src/contrib/tmcn_0.1-4.tar.gz")
package_paths = paste(dir_name, basename(urls), sep = "/")
for (i in 1:length(urls)) {
    download.file(urls[i], package_paths[i])
    install.packages(package_paths[i], repos = NULL, type="source")
}


