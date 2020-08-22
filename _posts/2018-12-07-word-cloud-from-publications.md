---
layout: post
title: "Word Cloud From Publications"
date: 2018-12-07T21:52:53+00:00
---


Word cloud ([Tag cloud](https://en.wikipedia.org/wiki/Tag_cloud)) has become a very popular visualization method for text data, despite it is almost useless in drawing statistically-relevent conclusions. Word clouds can, however, be a quick way to present research interests on [personal webpages](https://wckdouglas.github.io). 

![]({{ site.baseurl }}/assets/research_images/genomics.png)

In this blog post, I will show how to use [python](https://amueller.github.io/word_cloud/generated/wordcloud.WordCloud.html) to generate word cloud from a list of pdf files (a common file format for scientific publications).


We will need several python packages; [wordcloud](https://amueller.github.io/word_cloud/index.html), [PyPDF2](https://github.com/mstamy2/PyPDF2), [nltk](https://www.nltk.org/) and [matplotlib](https://matplotlib.org/), which can all be install from the ```conda-forge``` channel from [conda](https://conda.io/).


- setting up the environment

```bash
conda create -n pdf_wordcloud python3 wordcloud \
            pypdf2 matplotlib nltk nltk_data
```

- activating the environment 

```bash
source activate pdf_wordcloud
```


- here goes the scipt 

TL;DR The script is deposited on [github](https://github.com/wckdouglas/wckdouglas.github.io/blob/master/assets/scripts/generate_wordcloud.py).

First import all the things that are needed:

```python
import string
import re
import glob
import matplotlib.pyplot as plt
import wordcloud
import PyPDF2
import nltk
from calendar import month_name
from nltk.corpus import stopwords
```

In English, there are some general words (e.g. "you", "me", "is") that are not necessarily helpful in natural language processings. We call these [stop words](http://xpo6.com/list-of-english-stop-words/) and we want to exclude these words from our text database. Each of the `NLTK` and `wordcloud` package provides a list of stop words. So we will curate a list of stop words for filtering out the stop words in later steps.

```python
ENGLISH_STOP = set(stopwords.words('english'))
```

I implemented the wordcloud as a python object, and only the required initializing input is the directory of the PDF files, and I also curated some extra words (```self.paper_stop```) that maybe publication-specific stop words (e.g. "Figure", "Supplementary" and dates, in this case).

```python
class research_wordcloud():
    '''
    Make word cloud from all PDF under a folder

    Usage:
    rs = research(paper_path)
    rs.extract_text()
    rs.filter_text()
    rs.generate_wordcloud(figurename)
    '''
    def __init__(self, paper_path):
        '''
        find all pdf under paper_path
        '''
        self.paper_path = paper_path
        self.PDFs = glob.glob(paper_path + '/*pdf') #any PDF can be found?
        self.texts = ''  # store all texts
        self.tokens = None
        self.words = None
        self.paper_stop = ['fig','figure','supplementary', 'author','press',
                            'PubMed', 'manuscript','nt','et','al', 'laboratory',
                            'article','cold','spring','habor','harbor',
                            'additional', 'additionalfile','additiona file']
        months = [month_name[i].lower() for i in range(1,13)]
        self.paper_stop.extend(months)
        self.paper_stop.extend(list(map(lambda x: x.capitalize(), self.paper_stop)))
        self.paper_stop = set(self.paper_stop)
```


And then, I implemented a function to retrieve texts from the PDF files using PyPDF2:

```python
    def extract_text(self):
        '''
        read pdf text
        '''
        for pdf in self.PDFs:
            with open(pdf, 'rb') as paper:
                pdf = PyPDF2.PdfFileReader(paper)
                for page_num in range(pdf.getNumPages()-1): #skip reference
                    page = pdf.getPage(page_num)
                    self.texts += page.extractText()
```

And a also function for filtering out stop words, as well as verbs. [NLTK](https://www.nltk.org) offers implementations to 1. [tokenizing words](https://www.techopedia.com/definition/13698/tokenization) (```nltk.word_tokenize```) from the full text, and 2. [identifying if a word is a noun or verb, etc](https://www.nltk.org/book/ch05.html)  (```nltk.pos_tag```).

```python
    def filter_text(self):
        '''
        remove stop words and punctuations
        '''
        self.tokens = nltk.word_tokenize(self.texts)
        self.tokens =  nltk.pos_tag(self.tokens) #(tag the nature of each word, verb? noun?)

        self.words = []
        num_regex = re.compile('[0-9]+')
        for word, tag in self.tokens:
            IS_VERB = tag.startswith('V')
            IS_STOP = word in set(string.punctuation)
            IS_ENGLISH_STOP = word in set(ENGLISH_STOP)
            IS_WORDCLOUD_STOP = word in wordcloud.STOPWORDS
            IS_NUMBER = num_regex.search(word)
            IS_PAPER_STOP = word in self.paper_stop
            condition = [IS_VERB, IS_STOP, IS_ENGLISH_STOP,
                        IS_WORDCLOUD_STOP, IS_NUMBER, IS_PAPER_STOP]
            if not any(condition):
                if word == "coli":
                    self.words.append('E. coli') #unfortunate break down of E. coli
                else:
                    self.words.append(word)

        self.words = ' '.join(self.words)
```

Now, we can generate a wordcloud from the words we have curated.

```python
    def generate_wordcloud(self, figurename):
        '''
        plot
        '''
        wc = wordcloud.WordCloud(  
                collocations=False,
                background_color='white',
                max_words=200,
                max_font_size=40, 
                scale=3
        )
        try:
            wc.generate(self.words)
            plt.imshow(wc, interpolation="bilinear")
            plt.axis('off')
            plt.savefig(figurename, bbox_inches='tight', transparent=True)
            print('Written %s' %figurename)
        except ValueError:
            print(self.words)
```


So to run the whole thing:

```python
PDF_path = '/home/wckdouglas/all_my_papers/'
wordcloud_image = '/home/wckdouglas/research_wordcloud.png'

wc = research_wordcloud(PDF_path)
wc.extract_text()
wc.filter_text()
wc.generate_wordcloud(wordcloud_image)
```
