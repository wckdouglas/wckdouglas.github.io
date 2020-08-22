---
layout: post
comments: TRUE
title:  "Character vector splitting in R"
date:   2015-05-19
categories: mediator feature
tags: featured
---

Occasionally, I would encounter a problem in *R* where I want to split a string in a character columns with the same separator. However, there's is no function in *R* that is capable of doing that, and the **strsplit** function always return a list which I have to **unlist** it.

So today, I finally typed up a *Rcpp* function to ease my work and the code is as followed.

<script src="https://gist.github.com/wckdouglas/c20d8dd31825bbe08569.js"></script>

The function takes three inputs:


* The character vector that is being split
* separator 
* the piece that is desired  

---

Test the code:

```r
library(Rcpp)
sourceCpp('~/scripts/R/Rcpp/string_split.cpp')

testVector <- rep('I~am~a~boy',10)
for (i in 1:4){
	print(string_split(testVector,'~',i))
}
```

```
##  [1] "I" "I" "I" "I" "I" "I" "I" "I" "I" "I"
##  [1] "am" "am" "am" "am" "am" "am" "am" "am" "am" "am"
##  [1] "a" "a" "a" "a" "a" "a" "a" "a" "a" "a"
##  [1] "boy" "boy" "boy" "boy" "boy" "boy" "boy" "boy" "boy" "boy"
```

Benchmarking:


```r
library(rbenchmark)
library(ggplot2)
```

```
## Loading required package: methods
```

```r
r_string_split <- function(x){
	sapply(x,function(y) unlist(strsplit(x,'~'))[2])
}

bm <- benchmark(string_split(testVector,'~',2),r_string_split(testVector))
bm
```

```
##                               test replications elapsed relative user.self
## 2       r_string_split(testVector)          100   0.050       25     0.049
## 1 string_split(testVector, "~", 2)          100   0.002        1     0.001
##   sys.self user.child sys.child
## 2        0          0         0
## 1        0          0         0
```

```r
ggplot(data = bm,aes(x = test, y = relative)) +
		geom_bar(stat='identity') +
		theme(axis.text.x = element_text(angle=90,
										hjust = 1,
										vjust = 0.5))+
		labs(y = 'relative speed',title = 'benchmarking result')
```

![plot of chunk unnamed-chunk-2]({{ site.url }}/assets/article_images/string/unnamed-chunk-2-1.png) 

The *c++* function is ~25x faster.
