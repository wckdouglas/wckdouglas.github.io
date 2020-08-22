---
layout: post
title: Splitting Fastq file for high throughtput computing
author: "Dougals Wu"
date:   2015-08-06
categories: mediator feature
tags: featured
---

Most of the time reads from the massively parallel sequencers (e.g. Illumina) are treated as individual records and undergo same analytic pipeline (adaptor trimming, mapping, etc.) in parallel. Run time can be improved if high-throughput computing (HTC) resources is available. As encouraged by HTC architecture, large files are splitted into smaller pacakge and run in a massively parallel way. In the world of genetics, often a large fastq file can be split to smaller fastq files and throw to the computing nodes. In this way, splitting files become a important step whenever results are coming down from the sequencer. However, raw fastq files are often come in gzip format, the native *UNIX* **split** command cannot take in gzip format and output gzip format. Thus, I have written a **c++** program to make this more effective. This program supports *gzip I/O*. The code is hosted with my other [fastq-tools on github](https://github.com/wckdouglas/fastq-tools). 

```
usage: bin/splitFastq -i <fqfile> -n <# of record per file> -o <prefix> [-z]
[options]
-i    <fastq file> can be gzipped
-n    <number of record in each splitted file> default: 10000000
-o    <prefix>
-z    optional: gzip output
```

<script src="https://gist.github.com/wckdouglas/052bd7c986fd65b3673c.js"></script>

