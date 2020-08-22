---
layout: post
title: Extracting of junctions from bam file
author: "Dougals Wu"
date:   2015-07-28
categories: mediator feature
tags: featured
---

Here's a program for converting bed file to junctions. can be cloned from [Github](https://github.com/wckdouglas/filterSamFile).

	usage ./bin/bedToJunction <filename>|<stdin>
	
	suggested usage: bamtobed -i <bamfile> -cigar | ./bin/bedToJunction - > junction.bed
	**** use <-> when using stdin
	Needed a bed file with cigar string
	output file contains six columns:
		      column 1:        chromosome name
			  column 2:        junction start position (0-base start pos)
			  column 3:        junction end position (0-base start pos)
			  column 4:        name (ordered by chrom)
		      column 5:        number of reads supporting
		      column 6:        strand [+/-]

<script src="https://gist.github.com/wckdouglas/58918b7261163d6f996a.js"></script>
