---    
layout: post    
title: A note for creating R-packages    
author: "Dougals Wu"    
date:   2015-10-28    
categories: mediator feature    
tags: featured    
---    
    
This is the notes for myself on creating R packages in 6 steps, following [Jeff Leeks's guide](https://github.com/jtleek/rpackages) and [Hadley Wickham's guide](http://r-pkgs.had.co.nz/description.html).    
    
### Step 1: Loading necessary packages  ###
    
	library("devtools")    
	library("roxygen2")    
    
### Step 2: Create package folder ###   
    
	create('packagename')    

This will create a folder with **packagename** in your working directory with the following files:    
    
* DESCRIPTION         
* NAMESPACE    
* R (folder)    
* Man (folder)    
* packagename.Rproj (file)    
    
Open  **packagename.Rproj** with *Rstudio*, this will bring you to the package directory    
    
### Step 3: Add functions ###
    
In the *R* folder, write your desire functions in to files, one function per file.    
    
Remeber to add the following lines (started with #')on the top of each function.    
    
	#' Title    
	#'    
	#' Description..........    
	#' ...................    
	#'    
	#' @param x1: \code{inputParameter1}    
	#' @param x2: \code{inputParameter2}    
	#'    
	#' @return y1: what is it    
	#'    
	#' @keywords keywords    
	#'    
	#' @export    
	#'    
	#' @examples    
	#' R code here showing how your function works    
    
	try <- function(x1,x2){    
		y1 <- x1 + x2    
		return(y1)    
	}    
    
**@export** is needed if this function is intended to be used by the users.    
    
### Step 4: Add manuals for functions ###

As the header lines for each function is written in the desired format, it can be automatically translate into manual page by *devtools* and *roxygen2*.    
    
	document("packagename")    
    
This writes the manual for each functions in to the *man* folder.    
    
### Step 5: Add informations into DESCRIPTION   ###
 
The *DESCRIPTION* is automatically generated as:    
    
    Package: packagename    
    Title: What the Package Does (one line, title case)    
    Version: 0.0.0.9000    
    Authors@R: person("First", "Last", email = "first.last@example.com", role = c("aut", "cre"))    
    Description: What the package does (one paragraph).    
    Depends: R (>= 3.2.2)    
    License: What license is it under?    
    LazyData: true    
    
Fill up the infomation without messing with the format, and add the following:    
    
	Imports:    
	    dplyr,    
		stringi    
	Suggests:    
		dplyr,    
		stringi    
    
This will tells `R` to install everything under **Imports** when this package is installed, whereas everything under **suggests** will not.     
    
### Step 6: Push to github ###
On *github*, create a repository naming it *packagename*    
    
	echo "# packagename" >> README.md    
	git init    
	git add *    
	git commit -m "first commit"    
	git remote add origin https://github.com/username/packagename.git    
	git push -u origin master    
    
Now, the package can be install using the command:    
    
	library(devtools)    
	install_github('packagename',username='username')    
    
## Rcpp add on  ###

So in the project Directory, the folder tree should be like:    
    
.    
    ├── DESCRIPTION    
    ├── NAMESPACE    
    ├── R    
    │   └── function1.R    
    │   └── function2.R    
    ├── README.md    
    ├── man    
    │   └── function1.Rd    
    │   └── function2.Rd    
    └── packagename.Rproj    
    
Do the following:    
    
	mkdir src    
	mkdir -p inst/include    
    
Put the **.cpp** files in the *src* and **.hpp** files in *inst/include*.    
And do:    
    
	echo "PKG_CPPFLAGS += -I../inst/include/    
	PKG_CXXFLAGS = $(CXX1XSTD)" >> src/Makevars    
    
For every cpp functions that needed to be export into R space,    
Add the following before defining the function, no comments are allowed between this phrase and the funciton:    
    
	// [[Rcpp::export]]    
	void function(int x, int y){    
	}    
