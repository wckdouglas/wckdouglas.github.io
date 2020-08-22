---
layout: post
title: "Matplotlib figure legends"
date: 2017-12-04
---

[Matplotlib](https://matplotlib.org/) is highly customizable, and having a huge code base means it might not be easy to find what I need quickly. 

A recurring problem that I often face is customizing figure legend. Although Matplotlib website provides excellent [document](https://matplotlib.org/users/legend_guide.html), I decided to write down some tricks that I found useful on the topic of handling figure legends. 

First, as always, load useful libraries and enable [matplotlib magic](http://ipython.readthedocs.io/en/stable/interactive/magics.html#magic-matplotlib).


```python
%matplotlib inline

import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
import seaborn as sns
from itertools import izip
import pandas as pd
import numpy as np
```

The first thing I found useful is to create a figure legend out of nowhere. 

In this example, I synthesized poll data with 'yes' or 'no' as the only choices, and try to plot color-coded bar graph from these two data points.


```python
ax = plt.subplot(111)
answers = ['yes','no']
votes = [10,20]
colors = ['blue','red']
sns.barplot(x=answers, y = votes, palette=colors, ax=ax)
sns.despine()
```


![png]({{ site.baseurl}}/assets/article_images/matplotlib_legend/output_3_0.png)


On the above plot, legend could not be added using ```ax.legend()```, since they were not labeled. In this case, I have to use ``patches`` from ``matplotlib`` to make the legend handles, and add to the figure by ```ax.legend()``` 


```python
ax = plt.subplot(111)
answers = ['yes','no']
votes = [10,20]
sns.barplot(x=answers, y = votes, palette=colors, ax=ax)
sns.despine()
pat = [mpatches.Patch(color=col, label=lab) for col, lab in zip(colors, answers)]
ax.legend(handles=pat, bbox_to_anchor = (1,0.5))
```



![png]({{ site.baseurl}}/assets/article_images/matplotlib_legend/output_5_1.png)


Another frequently-encountered problem is the duplicate legend labels.

To illustrate this problem, I simulated a dataset of movements of 10 particles of two particle types bwtween two time points in a 2D space (**x1, y1** are the initial coordinates; **x2, y2** are the new coordinates; **label**
indicates the particle types). I also wrote a color encoder function for assigning distintive color to each particle type.


```python
def color_encoder(xs, colors=sns.color_palette('Dark2',8)):
    '''
    color encoding a categoric vector
    '''
    xs = pd.Series(xs)
    encoder = {x:col for x, col in izip(xs.unique(), colors)}
    return xs.map(encoder)

sim = pd.DataFrame(np.random.rand(10,4), columns = ['x1','x2', 'y1','y2']) \
    .assign(label = lambda d: np.random.binomial(1, 0.5, 10)) \
    .assign(color = lambda d: color_encoder(d.label))
sim.head()
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>x1</th>
      <th>x2</th>
      <th>y1</th>
      <th>y2</th>
      <th>label</th>
      <th>color</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>0.902625</td>
      <td>0.755530</td>
      <td>0.211558</td>
      <td>0.512878</td>
      <td>1</td>
      <td>(0.105882352941, 0.619607843137, 0.466666666667)</td>
    </tr>
    <tr>
      <th>1</th>
      <td>0.327010</td>
      <td>0.275663</td>
      <td>0.876240</td>
      <td>0.821259</td>
      <td>1</td>
      <td>(0.105882352941, 0.619607843137, 0.466666666667)</td>
    </tr>
    <tr>
      <th>2</th>
      <td>0.193913</td>
      <td>0.934108</td>
      <td>0.746931</td>
      <td>0.826095</td>
      <td>1</td>
      <td>(0.105882352941, 0.619607843137, 0.466666666667)</td>
    </tr>
    <tr>
      <th>3</th>
      <td>0.190888</td>
      <td>0.263192</td>
      <td>0.331592</td>
      <td>0.081737</td>
      <td>0</td>
      <td>(0.850980392157, 0.372549019608, 0.0078431372549)</td>
    </tr>
    <tr>
      <th>4</th>
      <td>0.884696</td>
      <td>0.221513</td>
      <td>0.346046</td>
      <td>0.071234</td>
      <td>0</td>
      <td>(0.850980392157, 0.372549019608, 0.0078431372549)</td>
    </tr>
  </tbody>
</table>
</div>



To plot the movement, I iterated over the [pandas](https://pandas.pydata.org/) ``DataFrame`` object and plotted a line between the initial and the new coodinate for each particle at a time.


```python
fig = plt.figure()
ax = fig.add_subplot(111)
for index , row in sim.iterrows():
    ax.plot([row['x1'], row['x2']], [row['y1'],row['y2']], 
               label = row['label'], 
               color = row['color'])
ax.legend()
sns.despine()
```


![png]({{ site.baseurl}}/assets/article_images/matplotlib_legend/output_9_0.png)


And the default legend produced one handler for each line. To simplify the legend, I found an elegant solution on [stackoverflow](https://stackoverflow.com/questions/13588920/stop-matplotlib-repeating-labels-in-legend), that used ``dict`` object in python to remove redundant legend labels. 


```python
fig = plt.figure()
ax = fig.add_subplot(111)
for index , row in sim.iterrows():
    ax.plot([row['x1'], row['x2']], [row['y1'],row['y2']], 
               label = row['label'], 
               color = row['color'])
ax.legend()
handles, labels = ax.get_legend_handles_labels()  
lgd = dict(zip(labels, handles))
ax.legend(lgd.values(), lgd.keys())
sns.despine()
```


![png]({{ site.baseurl}}/assets/article_images/matplotlib_legend/output_11_0.png)

There's no doubt ***R*** is much better in figure plotting, thanks to [ggplot2](http://ggplot2.org/). But in my use case, I found ***python*** much more flexible in many other ways, such as text processing, and building useful [software](https://wckdouglas.github.io/sequencsing_tools/). In ***python***, there are several attempts on building grammar of graphics, such as [ggpy](https://github.com/yhat/ggpy), [Altair](https://altair-viz.github.io/) and [plotnine](https://plotnine.readthedocs.io/en/stable/). Out of these packages, I have tried **plotnine**. It is a fairly new pacakge and is coming close, but as of this point it is still not comparable to ggplot2 in ***R***.

## Update ##

I have implemented a [color encoder](https://github.com/wckdouglas/sequencing_tools/blob/master/sequencing_tools/viz_tools/__init__.py#L120) in ***python*** for better color controls:

``` python
from sequencing_tools.viz_tools import color_encoder, okabeito_palette

ax = plt.subplot(111)
ce = color_encoder()   # initiate the encoder
colors = ce.fit_transform(answers, okabeito_palette())  # fit categories to colors
sns.barplot(x=answers, y = votes, palette=colors, ax=ax)
sns.despine()
pat = [mpatches.Patch(color=col, label=lab) for lab, col in ce.encoder.items()] # ce.encoder is a dictionary of {label:color}
ax.legend(handles=pat, bbox_to_anchor = (1,0.5))
```

![png]({{ site.baseurl}}/assets/article_images/matplotlib_legend/color_encoder.png)

``` python
ce.encoder   #   {'no': '#E69F00', 'yes': '#56B4E9'}
```
