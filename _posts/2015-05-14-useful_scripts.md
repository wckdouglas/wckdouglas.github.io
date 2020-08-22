---
title: "useful R function"
date: '2015-05-14'
layout: post
output: pdf_document
tags: featured
categories: mediator feature
---

These is a function that I recursively used in analysis using R. I have rewritten in *Rcpp* to make use of vectorization and make the task faster.

---

<script src="https://gist.github.com/wckdouglas/22a2064ae51162ddd903.js"></script>

---

### Benchmarking
The function takes in a numeric vector and make all the NA values into 0, which is handy when there's missing data in the table.

I will test the speed compare to the original **ifelse** R equivalent command.


```r
library(Rcpp)
library(microbenchmark)

#load/compile the functions
sourceCpp('~/scripts/R/Rcpp/Rfunctions.cpp')

#simulate data
a <- sample(c(rnorm(100000,1:100),rep(NA,10000)))

#test second function
microbenchmark(removeNA(a),ifelse(is.na(a),0,a))
```

```
## Unit: microseconds
##                    expr       min         lq      mean    median       uq
##             removeNA(a)   665.065   771.2185  2289.387  1122.832  1600.63
##  ifelse(is.na(a), 0, a) 36003.881 43070.1215 62004.357 49713.592 90096.88
##        max neval cld
##   53051.31   100  a 
##  132315.03   100   b
```

From the experiment, *Rcpp* functions make use of vectorization and increase the speed significantly (did not do a t-test, but probably p<0.05).
