---
layout: post
title:  "A script to remove fastq reads given a read ID file-updated"
date:   2015-04-24
categories: mediator feature
tags: featured
---
### An update to my [previous post](http://wckdouglas.github.io/mediator/feature/2015/03/18/fastq_extract.html)

After my qualifying exam, I am trying to allocate some time for learning different new things, one thing I have been wanted to do for a while is to implement the [python script](https://github.com/wckdouglas/fastq_manipulation/blob/master/remove_reads.py) in [C](http://en.wikipedia.org/wiki/C_programming_language). This script utilized [Heng Li's kseq library and khash library](https://github.com/lh3)

----
<script src="https://gist.github.com/wckdouglas/8f858c9f38604f6143ca.js"> </script>



---- 
### Benchmarking:
For a Fastq file with 8720139 reads, id file with 4477244 ids:

	 
	$ time ./filterReads fastqFile  idFile | grep -c '^@'
	## 4242895
	## ./filterReads fastqFile   
	## 18.07s user 
	## 1.89s system 
	## 99% cpu 
	## 20.154 total
	## grep  -c '^@'  1.83s user 0.38s system 10% cpu 20.153 total
	
	$ time ./remove_reads.py fastqFile  idFile | grep -c '^@'
	## 4242895
	## ./remove_reads.py fastqFile   
	## 62.37s user 
	## 2.81s system 
	## 99% cpu 
	## 1:05.44 total
	## grep -c '^@NS'  2.41s user 0.73s system 4% cpu 1:05.44 total
	
So it seems like 4 times faster in C.

Another Major difference, [filterReads.c](https://github.com/wckdouglas/fastq-tools/blob/master/filterReads.c) hashed id list instead of fastq file when comparing to [remove_reads.py](https://github.com/wckdouglas/fastq-tools/blob/master/remove_reads.py).


Addition reading: [https://github.com/lh3/readfq](https://github.com/lh3/readfq)


