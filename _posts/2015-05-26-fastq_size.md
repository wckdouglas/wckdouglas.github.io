---
layout: post
comments: TRUE
title:  "Counting a list of fastq files"
date:   2015-05-26
categories: mediator feature
tags: featured
---

As sequencing experiments generate batches of fastq file after demultiplexing, I wrote a script for getting the size of a list of fastq files in the path:

<script src="https://gist.github.com/wckdouglas/f91f62c3634853da73d2.js"></script>

---
Usage:

``` bash
./fastqSize <'$fastqpath/*fastq'>|<'$fastqpath/*fastq.gz'>
```
And this will output a very nice tab-deliminated format of file name on the first column and sequence count on the second.

The input can be *gzip* file as well, but is determined by the filename.

The code is deposited on [github](https://github.com/wckdouglas/fastq-tools) along with my other fastq manipulation tools. 

*Compiling requires [gzstream library](http://www.cs.unc.edu/Research/compgeom/gzstream/)

