---
layout: post
title: "Plasma Nucleotide Sequencing"
date: 2016-03-24
---

I have been wondering what people do with nucleotide sequencings in blood plasma, so I decided to do a bit of data mining in pubmed database to answer this question. 

I searched pubmed with the key words: 'plasma sequencing', and built a network based on the search results using the words in their titles.


The network is plotted here:
![]({{ site.baseurl }}/assets/article_images/plasmaSeq/titleWordingNetwork.png)


From the words network, I would say plasma sequencings have been applied on non-invasive screening in pregnancies and cancer patients.

The following is the script that I used to generate the figure. 

````python
#!/usr/bin/env python

import matplotlib 
matplotlib.use('Agg')
from Bio import Entrez, Medline
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
import numpy as np
import itertools
import networkx as nx

def parseingRcords(record, wordCombCount):
    """
    for each word in the title, paired with the other words and make it a record
    """
    title = record['TI']
    wordList = [word for word in title.split(' ') if len(word) > 3]
    for comb in itertools.combinations_with_replacement(wordList,2):
        wordCombCount.setdefault(comb,0)
        wordCombCount[comb] += 1
    return wordCombCount 


def searchPubMed(keyword, wordCombCount, articleCount, searchCount):
    """
    using entrez API for searching the articles with the key word
    """
    maxFetch = 100000
    startPoint = searchCount * maxFetch
    result = Entrez.esearch(db='pubmed',  term=keyword, retmax=maxFetch, restart = startPoint)
    ids = Entrez.read(result)['IdList']
    h = Entrez.efetch(db='pubmed', id=ids, rettype="Medline", retmode='text')
    records = Medline.parse(h)
    for record in records:
        wordCombCount = parseingRcords(record, wordCombCount)
    searchCount += 1
    print 'Finished searching %i articles' %(maxFetch + startPoint)
    return searchCount, articleCount, wordCombCount

def plotNetwork(df):
    """
    throwing pandas data frame to networkx and plot
    """
    figurename = 'titleWordingNetwork.pdf'
    graph = nx.from_pandas_dataframe(df,'word1','word2','count')
    nx.draw_networkx(graph, with_labels=True, edge_color = 'green', alpha = 0.7)
    plt.savefig(figurename)
    print 'Written file: %s' %figurename
    return 0

def main():
    keyword = 'plasma+sequencing'
    Entrez.email = 'wckdouglas@gmail.com'
    wordCombCount = {}
    articleCount = 0
    searchCount = 0
    searchTimes = 4
    for i in np.arange(searchTimes):
        searchCount, articleCount, wordCombCount = searchPubMed(keyword, wordCombCount, 
                                                articleCount, searchCount)
    df = pd.DataFrame(wordCombCount.items(), columns = ['comb','count'])
    df['word1'] = map(lambda x: x[0], df['comb'])
    df['word2'] = map(lambda x: x[1], df['comb'])
    df.drop('comb',axis=1,inplace=True)
    plotNetwork(df)
    return 0

if __name__ == '__main__':
    main()
````

