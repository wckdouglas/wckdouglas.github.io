---
layout: post
title:  "useful linux commands: datamash and parallel"
date:   2015-02-23
categories: mediator feature
tags: featured
---

GNU provided two handy tools: [datamash](http://www.gnu.org/software/datamash/) and [parallel](http://www.gnu.org/software/parallel/)

datamash can summarize data frames, just like the summary() function in R.

from a file that I generated two :

```sh
$ head  try.tsv
31	57
43	12
68	59
9	35
22	42
27	5
26	25
58	38
40	77
60	79
```

And to run datamash, just pipe in the input or use standard input..

```sh
$ datamash sum 1, sum 2 > try.tsv
384	429
$ cat try.tsv | datamash mean 1, mean 2
38.4	42.9
```

Apart from mean and sum, different operation can be used:

```sh
datamash --help
Usage: datamash [OPTION] op [col] [op col ...]

Performs numeric/string operations on input from stdin.

'op' is the operation to perform;
For grouping operations 'col' is the input field to use.

File operations:
  transpose, reverse
Numeric Grouping operations:
  sum, min, max, absmin, absmax
Textual/Numeric Grouping operations:
  count, first, last, rand
  unique, collapse, countunique
Statistical Grouping operations:
  mean, median, q1, q3, iqr, mode, antimode
  pstdev, sstdev, pvar, svar, mad, madraw
  pskew, sskew, pkurt, skurt, dpo, jarque
```

It is a lot more powerful than just getting summary, it can used for grouping and transposing data as well.

For Parallel,

its very handy if you want to run several commands in parallel such as gunzip,

```sh
$ cp try.tsv try1.tsv
$ parallel gzip {} ::: `ls *tsv`
$ ls
generateRandomNum.R try.tsv.gz          try1.tsv.gz
$ parallel gzip {} ::: `ls *tsv`
$ ls
generateRandomNum.R try.tsv             try1.tsv
```

the {} will be your files.

Alternatively, {.} and {/.} and use for substitution of basenames and file type.

```sh
$ parallel mv {} {.}.txt ::: *tsv
$ ls
generateRandomNum.R try.txt             try1.txt
$ cd ..
$ parallel mv {} gnu-commands/{/.}.tsv ::: gnu-commands/*txt
$ ls gnu-commands/
generateRandomNum.R try.tsv             try1.tsv
```

for osx:

```sh
brew install datamash
brew install parallel
```

Codes used in the post are deposited in [here](https://github.com/wckdouglas/gnu-commands).
