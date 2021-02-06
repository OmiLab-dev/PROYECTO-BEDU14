## ----Cap1_codeinstal,echo=TRUE,results="verbatim",cache=TRUE,eval=FALSE----
## sudo apt-get remove --purge r-base*

## ----Cap1_codeinstal2,echo=TRUE,results="verbatim",cache=TRUE,eval=FALSE----
## apt-get update && apt-get -y upgrade!

## ----Cap1_codeinstal3,echo=TRUE,results="verbatim",cache=TRUE,eval=FALSE----
## gpg --keyserver keyserver.ubuntu.com --recv-key E084DAB9!
## gpg -a --export E084DAB9 | sudo apt-key add

## ----Cap1_codeinstal4,echo=TRUE,results="verbatim",cache=TRUE,eval=FALSE----
## echo "deb http://cran.rstudio.com/bin/linux/ubuntu xenial/" |
## tee -a /etc/apt/sources.list

## ----Cap1_codeinstal5,echo=TRUE,results="verbatim",cache=TRUE,eval=FALSE----
## apt-get install r-base r-base-dev!

## ----Cap1_codeinstal6,echo=TRUE,results="verbatim",cache=TRUE,eval=FALSE----
## install.packages(maptools_0.9-2.tar.gz, repos = NULL, type=”source”)

## ----Cap1_codeinstal7,echo=TRUE,results="verbatim",cache=TRUE,eval=FALSE----
## install.packages(maptools_0.9-2.zip, repos = NULL, type=”source”)

