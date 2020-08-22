---
layout: post
title:  "Web scrapping"
date:   2015-03-03 
categories: mediator feature
tags: featured
---

Other than qualifying exam and regular lab work, I am laying my interest on web scraping lately.

In both of my favorite scripting language (and are the only ones that I am fairly competent on), R and python, I am trying out the most popular (?) packages [beautifulsoup](http://www.crummy.com/software/BeautifulSoup/#Download) and [rvest](https://github.com/hadley/rvest)

To get all the title from cnn US news for the day:

```python
#!/usr/bin/env python
  
import urllib2
from bs4 import BeautifulSoup

url = 'http://rss.cnn.com/rss/cnn_us.rss'
html = urllib2.urlopen(url)
soup = BeautifulSoup(html)
for line in soup.findAll('title'):
    print line.get_text()
```

Still exploring..............

