---
layout: post
title:  "Updated: False discovery rate control"
date:   2015-05-17
categories: mediator feature
tags: featured
---

A week ago, I posted a [post](http://wckdouglas.github.io/mediator/feature/2015/05/12/BH_adjust.html) attempting to speed up FDR filtering in *R* with *Rcpp*. However, that function requires manual sorting the of the p-values before throwing into the function.

As I did some research on sorting algorithms and index sorting in *c++*, I optimized my code with **std::pair** and **std::sort** in *c++*. And surprisingly (or not), this questions has been asked a lot of times on [stackoverflow](http://stackoverflow.com/questions/10287924/c-fastest-way-to-sort-a-list-of-number-and-their-index) and other websites. 
<script src="https://gist.github.com/wckdouglas/e3121c058c4fcf88cfd5.js"></script>

So testing again:


```r
library(data.table)
library(dplyr)
library(rbenchmark)
library(Rcpp)

sourceCpp('~/scripts/R/Rcpp/FDRcontrol.cpp')

r_equivalent <- function(pv,alpha){
	padj = p.adjust(pv,method='BH')
	return(ifelse(padj < alpha,1,0))
}

dat <- fread('~/scripts/R/Rcpp/pvalues.tsv')

alpha <- 0.01
p <- dat$p



result <- dat %>% 
		mutate(r = r_equivalent(p,alpha),
				cpp = FDRcontrol(p,alpha))
result
```

```
##                   p r cpp
##     1: 2.305163e-03 1   1
##     2: 6.429712e-01 0   0
##     3: 1.505003e-06 1   1
##     4: 1.060704e-04 1   1
##     5: 2.014278e-06 1   1
##    ---                   
## 40502: 7.241562e-01 0   0
## 40503: 5.023386e-02 0   0
## 40504: 6.178446e-01 0   0
## 40505: 8.729983e-01 0   0
## 40506: 4.176789e-01 0   0
```

```r
result %>%
	filter(r!=cpp)
```

```
## Empty data.table (0 rows) of 3 cols: p,r,cpp
```

Result is the same, so benchmarking as usual,


```r
benchmark(r_equivalent(p,alpha),FDRcontrol(p,alpha))
```

```
##                     test replications elapsed relative user.self sys.self
## 2   FDRcontrol(p, alpha)          100   0.578     1.00      0.56    0.018
## 1 r_equivalent(p, alpha)          100   4.653     8.05      4.51    0.133
##   user.child sys.child
## 2          0         0
## 1          0         0
```

Apparently, *R* and *matlab*/*octave* did a great job on easing the job for user-end work. Some dat-to-day functions, such as sort and return the indices, are so easily done in high-level languages. As a biologist, I have never thought about many of these questions until I start to hack the codes. And it's always the best way to understand a concept when I start coding it out. 

