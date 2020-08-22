---
layout: post
title: Tee Unix Command
author: "Dougals Wu"
date:   2015-09-11
categories: mediator feature
tags: featured
---

Unix system embraces the use of pipe `|`. An example using ensembl gene annotation:

```sh
$ curl ftp://ftp.ensembl.org/pub/release-81/gtf/homo_sapiens/Homo_sapiens.GRCh38.81.gtf.gz \
	| zcat \
	| head
```

Even in **R**, the package *dplyr* provides an interface to pipe input through multiple operations ([see my previous post for detail](http://wckdouglas.github.io/2015/04/dplyr)). And I am a big fan of using these kind of pipes, it is very common to include several operators in one line of command under this design. However, it was the only downside that I can't check the outputs the whole pipe line until I found out the `tee` command in unix.  


```sh
$ curl ftp://ftp.ensembl.org/pub/release-81/gtf/homo_sapiens/Homo_sapiens.GRCh38.81.gtf.gz \
	| zcat \
	| awk '$1==1' \
	| grep miRNA \
	| tee ~/Desktop/chr1.miRNA.gtf \
	| grep transcript \
	| wc -l

% Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 47.4M  100 47.4M    0     0   324k      0  0:02:29  0:02:29 --:--:--  306k
     632
```

This will save all the chromosome 1 miRNA records in the file *chr1.miRNA.gtf* on desktop and also count the number of miRNA (632) on chromosome 1.

So the `tee` comand is actually writing the input into a file and prinitng them as standard output at the same time. I am surprise this command is very underuse among Unix users, I think it can be very handy to everyone and should at least incoporate into one of your pipelines.
