---
layout: post
title: "TGIRT-seq vs TruSeq"
date: 2016-02-04
---

I have recently co-authored two publications on TGIRT-seq. The [latest one](http://rnajournal.cshlp.org/content/early/2016/01/29/rna.055558.115?top=1) aims on direct comparison between using thermostable group II intron reverse transcriptase for RNA-seq (namely TGIRT-seq) and commonly-used RNA-seq preps (TruSeq v2 and v3), where TruSeq v3 is strand specific RNA-seq prep, and TGIRT-seq is by nature has to be strand specific.

Basically what we found is very consistent with what we would expect by [sequencing plasma RNA with TGIRT](http://rnajournal.cshlp.org/content/early/2015/11/09/rna.054809.115).    

First off, TGIRT-seq clones full length structural RNAs as well as protein coding mRNAs. The below IGV is an example of snoRNA embbed between protein coding exons. 

![]({{ site.baseurl }}/assets/article_images/tgirt-seq/protein_coding.png)

Second, TGIRT-seq showed recovered the spike-ins concentration (a) and recapitulate differential expressions accurately (b). In both cases, TGIRT-seq shows similar results compare to TruSeq v2 and has a better performance compare to TruSeq v3.
![](https://pbs.twimg.com/media/CZ6ckB2UsAABYS_.png:large)

Third, adaptor attachment is done by end-to-end template switching of TGIRT, TGIRT-seq reduced sampling bias introduced by not-so-random hexamer priming from TruSeq protocols, enabling more comprehensively sampling of transcriptomes. However, there's an mysteric +3 nucleotide G bias on TGIRT-seq, which may be contributed by ligase.
![]({{ site.baseurl }}/assets/article_images/tgirt-seq/seqEnds.png)

Forth, strand specificity of TGIRT-seq is higher than that of TruSeq v3. 
![]({{ site.baseurl}}/assets/article_images/tgirt-seq/strandeness.png)

To conclude, TGIRT-seq can be useful for anyone who do RNA-seq, especially those who need strandeness information such as antisense RNA and structured RNA-seq like tRNA.

---

### Reference

1. Ryan M. Nottingham\*, **Douglas C. Wu\***, Yidan Qin, Jun Yao, Scott Hunicke-Smith, and Alan M. Lambowitz (2016). RNA-seq of human reference RNA samples using a thermostable group II intron reverse transcriptase. RNA. (*contributed equally)

2. Yidan Qin, Jun Yao, **Douglas C Wu**, Ryan M Nottingham, Sabine Mohr, Scott Hunicke-Smith, Alan M Lambowitz (2016). High-throughput sequencing of human plasma RNA by using thermostable group II intron reverse transcriptases. RNA. Vol. 22, no. 1.
