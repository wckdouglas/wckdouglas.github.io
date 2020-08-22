---
layout: page
title: SOFTWARE
permalink: /Software/
---

As I do programming exclusively on RNA/DNA-seq experiments bioinformatics analysis, all of the softwares I wrote are mainly focus on this aspect.

# [Sequencing tools](https://wckdouglas.github.io/sequencing_tools/) #

This is a python package that contains many of my day-to-day scripts and function for manuipulating SAM/BAM, Fastq, BED files from high-throughput genomic data.

# [Stock profiler](https://github.com/wckdouglas/wu-stock) #

<iframe src="https://wu-stock.herokuapp.com/" style="border:none ; width: 1000px; height: 500px"></iframe>

# UMI Design #

This is an [shiny app](https://wckdouglas.shinyapps.io/UMI_design/) to help designing unique molecular identifiers (UMI) primers. Backend of the app used poisson distribution to estimate how many times the barcode collision would occur. Idea from [Nicholas C. Wu](https://wchnicholas.github.io/)

<iframe src="https://wckdouglas.shinyapps.io/UMI_design/" style="border: none; width: 600px; height: 800px"></iframe>



# [fdrcontrol](https://github.com/wckdouglas/fdrcontrol.git) #

This is a *R* package that I wrote to speed up FDR control in multiple hypothesis testing. Vignettes is available [here](http://rawgit.com/wckdouglas/fdrcontrol/master/vignettes/fdrcontrol.html).

<img src='{{ site.url }}/assets/article_images/softwares/fdrcontrol.png'>

The package can be install via **devtools**.

	devtools::install_github('wckdouglas/fdrcontrol')
