#!/usr/bin/env Rscript 

getPostName <- function(x){
	unlist(strsplit(x,'\\.'))[1]
}

#function for rendering
makePost <- function (file){
	name <- getPostName(file)
	htmlFile <- paste0(name,'.html')
	mdFile <- paste0(name,'.md')
	resultMdFile <- paste0('../_posts/',mdFile)
	if (!file.exists(resultMdFile)){
		knitr::knit2html(input = file, output = mdFile)
		file.remove(htmlFile)
		file.rename(mdFile,resultMdFile)
	}else { print (paste('Skipping',file)) }
	return (0)
}

#main
Rmdfiles <- list.files(path='.',pattern='.Rmd')
nullResult <- sapply(Rmdfiles,makePost)
