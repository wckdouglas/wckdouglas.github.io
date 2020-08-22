---
layout: post
title: "Open Source Software Licenses"
date: 2017-09-23T09:31:52-05:00
---

As I am in the process of packaging a [python package](https://wckdouglas.github.io/sequencing_tools/) to facilitate my research, I was hoping to incorporate a [module](https://github.com/wckdouglas/sequencing_tools/blob/master/sequencing_tools/cutadapt_align.pyx) from the famous [cutadapt](http://cutadapt.readthedocs.io/en/stable/) adapter trimming tool. This leads me to consider some licensing issues towards whether it is okay to do this. Cutadapt used a [MIT license](https://github.com/marcelm/cutadapt/blob/master/LICENSE), below is a screenshot from the Github project of cutadapt:

![png]({{ site.baseurl}}/assets/article_images/oss_license/mit.png)

So MIT license basically provide all freedom to reuse/copy of the codes for whatever use I want. This is great! But what if the codes were licensed with something other than MIT?

As I started with basically ZERO knowledge on this topic, I first looked at some [stats on Github](https://github.com/blog/1964-open-source-license-usage-on-github-com). Oh! I have seen/heard GPL and BSD before. So what are the differences between them?

As I read through several blogs ([Titus Brown's blog](http://ivory.idyll.org/blog/2015-on-licensing-in-bioinformatics.html), [Jake Vanderplas's blog](http://www.astrobetter.com/blog/2014/03/10/the-whys-and-hows-of-licensing-scientific-code/) and [John Hunter's statement](http://nipy.sourceforge.net/nipy/stable/faq/johns_bsd_pitch.html)), I started to have some ideas on the difference between GPL and BSD/BSD-like licenses (e.g. MIT). So basically, any if any software adopted GPL-licensed code, the new software must be licensed under GPL as well ([copyleft](https://www.gnu.org/licenses/copyleft.en.html)). This is in some sense promoting open source software in a restrictive way. In contrast, MIT and BSD licenses allow adopters to do whatever they want. This is how BSD-licensed Unix being incorporated into Max OSX under the hood without any legal issues. 

Anyways, there a whole lot more open source licenses in the [community](https://opensource.org/licenses), a common choice is [Apache license](http://wesmckinney.com/blog/react-bsd-patents/), where it is explicitly stating a BSD-like license. 

To decide whether or not to license any codes, [unlicensed code is closed code, so any open license is better than none](http://www.astrobetter.com/blog/2014/03/10/the-whys-and-hows-of-licensing-scientific-code/). On this end, Github is providing a [nice way](https://github.com/blog/1530-choosing-an-open-source-license) to help choosing the right license and also creating license file in any repository.

It is as easy as:

1\. Create a file in the repository named as **LICENSE**,

![png]({{ site.baseurl}}/assets/article_images/oss_license/create_license.png)

2\. Click **choose a license template**,

![png]({{ site.baseurl}}/assets/article_images/oss_license/choosing_license.png)

And it is done!