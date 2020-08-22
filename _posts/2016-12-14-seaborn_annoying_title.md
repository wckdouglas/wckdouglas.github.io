---
layout: post
title:  "Seaborn anonying facet title"
category: post
date:   2016-12-14
comments: true
---

# Seaborn anonying facet title

This jupyter notbook intends to record how the facet title from ***seaborn FacetGrid*** can be aligned as ***ggplot2*** in ***R*** (Because I always forget).


```python
%matplotlib inline

import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd
sns.set_style('white')
```

First, lets read the data and make some labels for facetting later.

The [data](https://perso.telecom-paristech.fr/eagan/class/igr204/datasets) is a dataset that stores information from 1038 cameras.

### Read dataset


```python
url = 'https://perso.telecom-paristech.fr/eagan/class/igr204/data/Camera.csv'
df = pd.read_csv(url,sep=';',skiprows=[1]) \
    .assign(price_type = lambda d: map(lambda x: 'Expensive' if x>1000 else 'Cheap', d.Price))\
    .assign(year_type = lambda d: map(lambda x: 'Before 2002' if x < 2002 else 'After 2002', d['Release date']))
df.head()
```




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Model</th>
      <th>Release date</th>
      <th>Max resolution</th>
      <th>Low resolution</th>
      <th>Effective pixels</th>
      <th>Zoom wide (W)</th>
      <th>Zoom tele (T)</th>
      <th>Normal focus range</th>
      <th>Macro focus range</th>
      <th>Storage included</th>
      <th>Weight (inc. batteries)</th>
      <th>Dimensions</th>
      <th>Price</th>
      <th>price_type</th>
      <th>year_type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Agfa ePhoto 1280</td>
      <td>1997</td>
      <td>1024.0</td>
      <td>640.0</td>
      <td>0.0</td>
      <td>38.0</td>
      <td>114.0</td>
      <td>70.0</td>
      <td>40.0</td>
      <td>4.0</td>
      <td>420.0</td>
      <td>95.0</td>
      <td>179.0</td>
      <td>Cheap</td>
      <td>Before 2002</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Agfa ePhoto 1680</td>
      <td>1998</td>
      <td>1280.0</td>
      <td>640.0</td>
      <td>1.0</td>
      <td>38.0</td>
      <td>114.0</td>
      <td>50.0</td>
      <td>0.0</td>
      <td>4.0</td>
      <td>420.0</td>
      <td>158.0</td>
      <td>179.0</td>
      <td>Cheap</td>
      <td>Before 2002</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Agfa ePhoto CL18</td>
      <td>2000</td>
      <td>640.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>45.0</td>
      <td>45.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>2.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>179.0</td>
      <td>Cheap</td>
      <td>Before 2002</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Agfa ePhoto CL30</td>
      <td>1999</td>
      <td>1152.0</td>
      <td>640.0</td>
      <td>0.0</td>
      <td>35.0</td>
      <td>35.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>4.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>269.0</td>
      <td>Cheap</td>
      <td>Before 2002</td>
    </tr>
    <tr>
      <th>4</th>
      <td>Agfa ePhoto CL30 Clik!</td>
      <td>1999</td>
      <td>1152.0</td>
      <td>640.0</td>
      <td>0.0</td>
      <td>43.0</td>
      <td>43.0</td>
      <td>50.0</td>
      <td>0.0</td>
      <td>40.0</td>
      <td>300.0</td>
      <td>128.0</td>
      <td>1299.0</td>
      <td>Expensive</td>
      <td>Before 2002</td>
    </tr>
  </tbody>
</table>
</div>



### Default seaborn facet plot


```python
with sns.plotting_context('paper', font_scale = 1.3):
    p = sns.FacetGrid(data = df,
                      col = 'year_type',
                      row = 'price_type')
p.map(plt.scatter, 'Effective pixels','Dimensions')
```




    <seaborn.axisgrid.FacetGrid at 0x7f03f98bf690>




![png]({{ site.baseurl}}/assets/article_images/seaborn_files/seaborn_5_1.png)


The default ***seaborn FacetGrid*** generate an uglya and messy title template. I personally like the facetgrid style in ***ggplot2*** better. There's option in [seaborn](http://seaborn.pydata.org/)

### Make and customize margin titles ###


```python
with sns.plotting_context('paper', font_scale = 1.3):
    p = sns.FacetGrid(data = df,
                      col = 'year_type',
                      row = 'price_type',
                      margin_titles=True)
p.map(plt.scatter, 'Effective pixels','Dimensions')
p.set_titles(row_template = '{row_name}', col_template = '{col_name}')
```




    <seaborn.axisgrid.FacetGrid at 0x7f03f95fe0d0>




![png]({{ site.baseurl}}/assets/article_images/seaborn_files/seaborn_7_1.png)


There will be some overlapping on the row titles for some reason.

### Fix the overlapping texts ###

This is addressed in a [github issue](https://github.com/mwaskom/seaborn/issues/440), and I tend to look at the issue every time I do the same thing.


```python
with sns.plotting_context('paper', font_scale = 1.3):
    p = sns.FacetGrid(data = df,
                      col = 'year_type',
                      row = 'price_type',
                      margin_titles=True)
p.map(plt.scatter, 'Effective pixels','Dimensions')
[plt.setp(ax.texts, text="") for ax in p.axes.flat] # remove the original texts
                                                    # important to add this before setting titles
p.set_titles(row_template = '{row_name}', col_template = '{col_name}')
```




    <seaborn.axisgrid.FacetGrid at 0x7f03f8e5ea50>




![png]({{ site.baseurl}}/assets/article_images/seaborn_files/seaborn_9_1.png)
