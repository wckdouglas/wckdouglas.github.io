---
layout: post
title: "Sequencing costs"
date: 2018-04-05
---

As Illumina sequencings are becoming more and [more popular](https://ark-invest.com/wp-content/uploads/2014/08/GenBankNumbers-e1408037368293.png), there are various sequencing centers available for sequencing services around the nation. Here at UT-Austin, we have a renowned sequencing center ([UT-Austin GSAF](https://sites.cns.utexas.edu/cbrs/genomics/services/next-gen-sequencing)) that has been greatly helpful to my own work. However, recently we have had good experience with [MD Anderson Science Park Next-Generation Sequencing (NGS) Facility](https://www.mdanderson.org/research/research-resources/core-facilities/next-generation-sequencing-core.html). So in this post, I am going to compare the sequencing prices between these two centers for future reference.

Since the two sequencing centers have their sequencing prices posted online, I will do some web scraping to collect the data, and data cleaning for visualizing the comparisons.


```python
%matplotlib inline

import urllib.request
import pandas as pd
from bs4 import BeautifulSoup
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from sequencing_tools.viz_tools import okabeito_palette
```

# Science park price table #

For MD Anderson Science park price, I will download the data from their [website](https://www.mdanderson.org/research/research-resources/core-facilities/next-generation-sequencing-core/services.html).


```python
mda = 'https://www.mdanderson.org/research/research-resources/core-facilities/next-generation-sequencing-core/services.html'
mda_html = urllib.request.urlopen(mda)
soup = BeautifulSoup(mda_html, 'lxml')
tabs = soup.find_all('table')
table = tabs[-1]
mda_df = pd.read_html(str(table), 
                      flavor='bs4',
                     header=0,
                     index_col = 0)[0]
mda_df
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
      <th>NGS User Group Member Price (per lane)</th>
      <th>MDACC Faculty, UT System, BCM w/ MOU Price (per lane)</th>
      <th>*External Out-of-Network Price (per lane)</th>
    </tr>
    <tr>
      <th>Service</th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>HiSeq 3000</th>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>50 bp, single read</th>
      <td>$966.41</td>
      <td>$1,100.71</td>
      <td>$2,177.47</td>
    </tr>
    <tr>
      <th>75 bp, paired end</th>
      <td>$1,746.41</td>
      <td>$1,880.71</td>
      <td>$3,425.47</td>
    </tr>
    <tr>
      <th>100 bp, paired end</th>
      <td>$2,089.61</td>
      <td>$2,223.91</td>
      <td>$3,974.59</td>
    </tr>
    <tr>
      <th>150 bp, paired end</th>
      <td>$2,431.25</td>
      <td>$2,565.55</td>
      <td>$4,521.22</td>
    </tr>
    <tr>
      <th>NextSeq 500</th>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>High Output:</th>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>75 bp, single read</th>
      <td>$1,632.95</td>
      <td>$1,853.96</td>
      <td>$3,238.11</td>
    </tr>
    <tr>
      <th>75 bp, paired end</th>
      <td>$3,085.83</td>
      <td>$3,306.84</td>
      <td>$5,562.72</td>
    </tr>
    <tr>
      <th>150 bp, paired end</th>
      <td>$4,904.79</td>
      <td>$5,125.80</td>
      <td>$8,473.06</td>
    </tr>
    <tr>
      <th>Mid Output:</th>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>75 bp, paired end</th>
      <td>$1,232.55</td>
      <td>$1,453.56</td>
      <td>$2,597.47</td>
    </tr>
    <tr>
      <th>150 bp, paired end</th>
      <td>$1,941.83</td>
      <td>$2,162.84</td>
      <td>$3,732.32</td>
    </tr>
    <tr>
      <th>MiSeq</th>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>50 bp, single read (v2 chemistry)</th>
      <td>$948.99</td>
      <td>$1,132.53</td>
      <td>$1,358.78</td>
    </tr>
    <tr>
      <th>150 bp, paired end (v2 chemistry)</th>
      <td>$1,202.19</td>
      <td>$1,481.73</td>
      <td>$1,707.98</td>
    </tr>
    <tr>
      <th>300 bp, single read (v2 chemistry)</th>
      <td>$1,202.19</td>
      <td>$1,481.73</td>
      <td>$1,707.98</td>
    </tr>
    <tr>
      <th>300 bp, paired end (v3 chemistry)</th>
      <td>$1,782.99</td>
      <td>$2,177.73</td>
      <td>$2,403.98</td>
    </tr>
  </tbody>
</table>
</div>



Now, I need to clean up the table to make it more easily to manipulate. I will need a function to assign the platform (sequencing machines) for each run type (X bp, paired\|single end). Then, I will only look at the member price, since that's what we pay for.


```python
def clean_mda_index(idx, data_col):
    platform = ''
    clear = False
    new_idx = []
    for i, dc in zip(idx,data_col):
        if pd.isnull(dc):
            if clear:
                platform = ''
                clear=False
            platform = platform + i + '_'
            new_idx.append(platform)
        else:
            new_idx.append(platform + i)
            clear = True
    return new_idx
```


```python
mda_price_df = mda_df \
    .assign(seq_type = lambda d: clean_mda_index(d.index, d.iloc[:,0])) \
    .assign(seq_type = lambda d: np.where(d.seq_type.str.contains('Mid Output'),
                                         'NextSeq 500_' + d.seq_type,
                                         d.seq_type))\
    .reset_index() \
    .drop('Service', axis=1) \
    .pipe(lambda d: d[~pd.isnull(d.iloc[:,1])]) \
    .assign(platform = lambda d: d.seq_type.str.split('_', expand=True).iloc[:,0]) \
    .assign(basepair = lambda d: d.seq_type.str.extract('_([0-9]+)', expand=False).astype(int)) \
    .assign(ends = lambda d: d.seq_type.str.extract('(single|paired)', expand=False)) \
    .pipe(lambda d: d[~d.seq_type.str.contains('Mid')]) \
    .assign(md_price = lambda d: d.iloc[:,0].str.replace('[,$]','').astype(float))\
    .assign(machine = lambda d: d.platform.str.replace(' [0-9]+','')) \
    .assign(total_base = lambda d: np.where(d.ends == "paired", d.basepair * 2, d.basepair))\
    .assign(ends = lambda d: np.where(d.machine=="MiSeq", 'single', d.ends))\
    .filter(regex = 'platform|total|ends|md_price|machine')  \
    .drop_duplicates()
mda_price_df
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
      <th>platform</th>
      <th>ends</th>
      <th>md_price</th>
      <th>machine</th>
      <th>total_base</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>1</th>
      <td>HiSeq 3000</td>
      <td>single</td>
      <td>966.41</td>
      <td>HiSeq</td>
      <td>50</td>
    </tr>
    <tr>
      <th>2</th>
      <td>HiSeq 3000</td>
      <td>paired</td>
      <td>1746.41</td>
      <td>HiSeq</td>
      <td>150</td>
    </tr>
    <tr>
      <th>3</th>
      <td>HiSeq 3000</td>
      <td>paired</td>
      <td>2089.61</td>
      <td>HiSeq</td>
      <td>200</td>
    </tr>
    <tr>
      <th>4</th>
      <td>HiSeq 3000</td>
      <td>paired</td>
      <td>2431.25</td>
      <td>HiSeq</td>
      <td>300</td>
    </tr>
    <tr>
      <th>7</th>
      <td>NextSeq 500</td>
      <td>single</td>
      <td>1632.95</td>
      <td>NextSeq</td>
      <td>75</td>
    </tr>
    <tr>
      <th>8</th>
      <td>NextSeq 500</td>
      <td>paired</td>
      <td>3085.83</td>
      <td>NextSeq</td>
      <td>150</td>
    </tr>
    <tr>
      <th>9</th>
      <td>NextSeq 500</td>
      <td>paired</td>
      <td>4904.79</td>
      <td>NextSeq</td>
      <td>300</td>
    </tr>
    <tr>
      <th>14</th>
      <td>MiSeq</td>
      <td>single</td>
      <td>948.99</td>
      <td>MiSeq</td>
      <td>50</td>
    </tr>
    <tr>
      <th>15</th>
      <td>MiSeq</td>
      <td>single</td>
      <td>1202.19</td>
      <td>MiSeq</td>
      <td>300</td>
    </tr>
    <tr>
      <th>17</th>
      <td>MiSeq</td>
      <td>single</td>
      <td>1782.99</td>
      <td>MiSeq</td>
      <td>600</td>
    </tr>
  </tbody>
</table>
</div>



# UT GSAF price table#

For UT GSAF price, we will download the table from [UT GSAF website](https://wikis.utexas.edu/display/GSAF/Library+Prep+and+NGS+Pricing+Descriptions).


```python
gsaf = 'https://wikis.utexas.edu/display/GSAF/Library+Prep+and+NGS+Pricing+Descriptions'
gsaf_html = urllib.request.urlopen(gsaf)
soup = BeautifulSoup(gsaf_html, 'lxml')
tabs = soup.find_all('table')
gsaf_df = pd.read_html(tabs[0].prettify(), 
             flavor='bs4',
             index_col = None,
            header=0)[0] 
gsaf_df
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
      <th>Platform</th>
      <th>Run Type</th>
      <th>Internal / UT</th>
      <th>External Academic</th>
      <th>External Commercial</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>HiSeq 2500</td>
      <td>SR 50</td>
      <td>$1052</td>
      <td>$1331</td>
      <td>$1357</td>
    </tr>
    <tr>
      <th>1</th>
      <td>HiSeq 2500</td>
      <td>SR 100</td>
      <td>$1428</td>
      <td>$1806</td>
      <td>$1842</td>
    </tr>
    <tr>
      <th>2</th>
      <td>HiSeq 2500</td>
      <td>PE 125</td>
      <td>$2520</td>
      <td>$3187</td>
      <td>$3250</td>
    </tr>
    <tr>
      <th>3</th>
      <td>HiSeq 4000</td>
      <td>SR 50  (1)</td>
      <td>$ 1,043</td>
      <td>$ 1,319</td>
      <td>$1,345</td>
    </tr>
    <tr>
      <th>4</th>
      <td>HiSeq 4000</td>
      <td>PE 150  (1)</td>
      <td>$ 2,562</td>
      <td>$ 3,239</td>
      <td>$ 3,266</td>
    </tr>
    <tr>
      <th>5</th>
      <td>HiSeq 4000</td>
      <td>SR 50</td>
      <td>$ 1,697</td>
      <td>$ 2,146</td>
      <td>$ 2,173</td>
    </tr>
    <tr>
      <th>6</th>
      <td>HiSeq 4000</td>
      <td>PE 75</td>
      <td>$ 14,494</td>
      <td>$ 18,327</td>
      <td>$ 18,531</td>
    </tr>
    <tr>
      <th>7</th>
      <td>NextSeq 500</td>
      <td>SR 75 H.O  (1,3)</td>
      <td>$ 2,302</td>
      <td>$ 2,906</td>
      <td>$ 3,060</td>
    </tr>
    <tr>
      <th>8</th>
      <td>NextSeq 500</td>
      <td>PE 75 H.O  . (1,3)</td>
      <td>$ 3,826</td>
      <td>$ 4,834</td>
      <td>$ 4,988</td>
    </tr>
    <tr>
      <th>9</th>
      <td>NextSeq 500</td>
      <td>PE 150 H.O.</td>
      <td>$ 5,735</td>
      <td>$ 7,250</td>
      <td>$ 7,404</td>
    </tr>
    <tr>
      <th>10</th>
      <td>MiSeq</td>
      <td>V2 - 300 cycles</td>
      <td>$ 1,627</td>
      <td>$ 2,054</td>
      <td>$ 2,157</td>
    </tr>
    <tr>
      <th>11</th>
      <td>MiSeq</td>
      <td>V2 - 500 cycles  (1)</td>
      <td>$ 1,771</td>
      <td>$ 2,236</td>
      <td>$ 2,339</td>
    </tr>
    <tr>
      <th>12</th>
      <td>MiSeq</td>
      <td>V3 - 150 cycles</td>
      <td>$ 1,463</td>
      <td>$ 1,847</td>
      <td>$ 1,950</td>
    </tr>
    <tr>
      <th>13</th>
      <td>MiSeq</td>
      <td>V3 - 600 cycles  (1)</td>
      <td>$ 2,183</td>
      <td>$ 2,758</td>
      <td>$ 2,860</td>
    </tr>
  </tbody>
</table>
</div>



The resulting table is much more easier to be interpreted, since it is in a clean format. Again, I will only look at the Internal prices.


```python
gsaf_price_df = gsaf_df\
    .iloc[:, :3] \
    .assign(machine = lambda d: d.Platform.str.replace(' [0-9]+','')) \
    .assign(basepair = lambda d: d['Run Type'].str.extract(' ([0-9]+)', expand=False).astype(int)) \
    .assign(ends = lambda d: np.where(d['Run Type'].str.contains('PE'), 'paired', 'single')) \
    .assign(total_base = lambda d: np.where(d.ends == "paired", 
                                      d.basepair * 2, 
                                      d.basepair))\
    .assign(gsaf_price = lambda d: d['Internal / UT'].str.replace('[$.,]','').astype(float)) \
    .filter(regex = 'total|price|machine|ends|Platform')
gsaf_price_df
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
      <th>Platform</th>
      <th>machine</th>
      <th>ends</th>
      <th>total_base</th>
      <th>gsaf_price</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>HiSeq 2500</td>
      <td>HiSeq</td>
      <td>single</td>
      <td>50</td>
      <td>1052.0</td>
    </tr>
    <tr>
      <th>1</th>
      <td>HiSeq 2500</td>
      <td>HiSeq</td>
      <td>single</td>
      <td>100</td>
      <td>1428.0</td>
    </tr>
    <tr>
      <th>2</th>
      <td>HiSeq 2500</td>
      <td>HiSeq</td>
      <td>paired</td>
      <td>250</td>
      <td>2520.0</td>
    </tr>
    <tr>
      <th>3</th>
      <td>HiSeq 4000</td>
      <td>HiSeq</td>
      <td>single</td>
      <td>50</td>
      <td>1043.0</td>
    </tr>
    <tr>
      <th>4</th>
      <td>HiSeq 4000</td>
      <td>HiSeq</td>
      <td>paired</td>
      <td>300</td>
      <td>2562.0</td>
    </tr>
    <tr>
      <th>5</th>
      <td>HiSeq 4000</td>
      <td>HiSeq</td>
      <td>single</td>
      <td>50</td>
      <td>1697.0</td>
    </tr>
    <tr>
      <th>6</th>
      <td>HiSeq 4000</td>
      <td>HiSeq</td>
      <td>paired</td>
      <td>150</td>
      <td>14494.0</td>
    </tr>
    <tr>
      <th>7</th>
      <td>NextSeq 500</td>
      <td>NextSeq</td>
      <td>single</td>
      <td>75</td>
      <td>2302.0</td>
    </tr>
    <tr>
      <th>8</th>
      <td>NextSeq 500</td>
      <td>NextSeq</td>
      <td>paired</td>
      <td>150</td>
      <td>3826.0</td>
    </tr>
    <tr>
      <th>9</th>
      <td>NextSeq 500</td>
      <td>NextSeq</td>
      <td>paired</td>
      <td>300</td>
      <td>5735.0</td>
    </tr>
    <tr>
      <th>10</th>
      <td>MiSeq</td>
      <td>MiSeq</td>
      <td>single</td>
      <td>300</td>
      <td>1627.0</td>
    </tr>
    <tr>
      <th>11</th>
      <td>MiSeq</td>
      <td>MiSeq</td>
      <td>single</td>
      <td>500</td>
      <td>1771.0</td>
    </tr>
    <tr>
      <th>12</th>
      <td>MiSeq</td>
      <td>MiSeq</td>
      <td>single</td>
      <td>150</td>
      <td>1463.0</td>
    </tr>
    <tr>
      <th>13</th>
      <td>MiSeq</td>
      <td>MiSeq</td>
      <td>single</td>
      <td>600</td>
      <td>2183.0</td>
    </tr>
  </tbody>
</table>
</div>



I notice there's a duplicated price of HiSeq 4000 single end 50-nt (1043 USD vs 1697.0 USD), so I will take the lowest one, and merge with the science park prices.


```python
merge_df = gsaf_price_df\
    .groupby(['Platform','machine','ends','total_base'], as_index=False)\
    .agg({'gsaf_price':np.min})\
    .merge(mda_price_df, how ='outer')
merge_df
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
      <th>Platform</th>
      <th>machine</th>
      <th>ends</th>
      <th>total_base</th>
      <th>gsaf_price</th>
      <th>platform</th>
      <th>md_price</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>HiSeq 2500</td>
      <td>HiSeq</td>
      <td>paired</td>
      <td>250</td>
      <td>2520.0</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>1</th>
      <td>HiSeq 2500</td>
      <td>HiSeq</td>
      <td>single</td>
      <td>50</td>
      <td>1052.0</td>
      <td>HiSeq 3000</td>
      <td>966.41</td>
    </tr>
    <tr>
      <th>2</th>
      <td>HiSeq 4000</td>
      <td>HiSeq</td>
      <td>single</td>
      <td>50</td>
      <td>1043.0</td>
      <td>HiSeq 3000</td>
      <td>966.41</td>
    </tr>
    <tr>
      <th>3</th>
      <td>HiSeq 2500</td>
      <td>HiSeq</td>
      <td>single</td>
      <td>100</td>
      <td>1428.0</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>4</th>
      <td>HiSeq 4000</td>
      <td>HiSeq</td>
      <td>paired</td>
      <td>150</td>
      <td>14494.0</td>
      <td>HiSeq 3000</td>
      <td>1746.41</td>
    </tr>
    <tr>
      <th>5</th>
      <td>HiSeq 4000</td>
      <td>HiSeq</td>
      <td>paired</td>
      <td>300</td>
      <td>2562.0</td>
      <td>HiSeq 3000</td>
      <td>2431.25</td>
    </tr>
    <tr>
      <th>6</th>
      <td>MiSeq</td>
      <td>MiSeq</td>
      <td>single</td>
      <td>150</td>
      <td>1463.0</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>7</th>
      <td>MiSeq</td>
      <td>MiSeq</td>
      <td>single</td>
      <td>300</td>
      <td>1627.0</td>
      <td>MiSeq</td>
      <td>1202.19</td>
    </tr>
    <tr>
      <th>8</th>
      <td>MiSeq</td>
      <td>MiSeq</td>
      <td>single</td>
      <td>500</td>
      <td>1771.0</td>
      <td>NaN</td>
      <td>NaN</td>
    </tr>
    <tr>
      <th>9</th>
      <td>MiSeq</td>
      <td>MiSeq</td>
      <td>single</td>
      <td>600</td>
      <td>2183.0</td>
      <td>MiSeq</td>
      <td>1782.99</td>
    </tr>
    <tr>
      <th>10</th>
      <td>NextSeq 500</td>
      <td>NextSeq</td>
      <td>paired</td>
      <td>150</td>
      <td>3826.0</td>
      <td>NextSeq 500</td>
      <td>3085.83</td>
    </tr>
    <tr>
      <th>11</th>
      <td>NextSeq 500</td>
      <td>NextSeq</td>
      <td>paired</td>
      <td>300</td>
      <td>5735.0</td>
      <td>NextSeq 500</td>
      <td>4904.79</td>
    </tr>
    <tr>
      <th>12</th>
      <td>NextSeq 500</td>
      <td>NextSeq</td>
      <td>single</td>
      <td>75</td>
      <td>2302.0</td>
      <td>NextSeq 500</td>
      <td>1632.95</td>
    </tr>
    <tr>
      <th>13</th>
      <td>NaN</td>
      <td>HiSeq</td>
      <td>paired</td>
      <td>200</td>
      <td>NaN</td>
      <td>HiSeq 3000</td>
      <td>2089.61</td>
    </tr>
    <tr>
      <th>14</th>
      <td>NaN</td>
      <td>MiSeq</td>
      <td>single</td>
      <td>50</td>
      <td>NaN</td>
      <td>MiSeq</td>
      <td>948.99</td>
    </tr>
  </tbody>
</table>
</div>



Let's see if prices from both centers are correlated.


```python
plt.rc('xtick', labelsize=15)
plt.rc('ytick', labelsize=15)
plt.rc('axes',labelsize=15)
p = sns.FacetGrid(data = merge_df,
             hue = 'machine',
             size = 5)
p.map(plt.scatter, 'md_price','gsaf_price')
p.add_legend(title = '')
p.set(xlabel = 'MD Anderson Science park\nsequencing cost (USD)',
     ylabel = 'UT-Austin GSAF\nsequencing cost (USD)')

# label outlier
for i, row in merge_df.iterrows():
    if row['gsaf_price'] > 10000:
        label = row['machine'] + ' ' + str(row['total_base']) + ' bp'
        p.fig.axes[0].text(row['md_price'] + 200,
                           row['gsaf_price'],
                           label)

p.fig.axes[0].plot(range(5000), color = 'black')
```




    [<matplotlib.lines.Line2D at 0x11cd434a8>]




![png]({{ site.baseurl }}/assets/article_images/sequencing_costs/cor_plot.png)


We can see that sequencing prices from both centers are proportion to each other, with NextSeq runs tend to be of higher cost per sequenced base.

I noticed there was a HiSeq run being an outlier in the plot (~14000 USD at UT-Austin GSAF vs ~2000 USD at MDA Smithville), it is possibly a mis-labeling of a full run (8 lanes for HiSeq) price instead of a per-lane-price. For the next analysis, I will assume that's the case.

I am interested at the head-to-head comparisons between the two sequencing centers for different sequencing run types,


```python
merge_df = gsaf_price_df\
    .groupby(['Platform','machine','ends','total_base'], as_index=False)\
    .agg({'gsaf_price':np.min})\
    .merge(mda_price_df, how ='inner') \
    .filter(regex = 'price|machine|ends|base')\
    .pipe(pd.melt, id_vars = ['machine','ends','total_base'],
                 var_name = 'center',
                 value_name = 'price')\
    .assign(center = lambda d: np.where(d['center'].str.contains('gsaf'),
                                        'UT-Austin GSAF',
                                        'MD Anderson Science park')) \
    .assign(price = lambda d: np.where(d.price > 10000, d.price / 8, d.price))

p = sns.FacetGrid(data = merge_df,
             col = 'machine',
             sharex=False,
             size = 5)
p.map(sns.barplot, 'total_base',
                  'price',
                  'center',
                  palette = okabeito_palette(),
                  hue_order = ['MD Anderson Science park',
                              'UT-Austin GSAF'])
p.add_legend(bbox_to_anchor=(0.5,0.8),
            fontsize=12)
p.set(xlabel = '',
     ylabel = '')
p.set_titles('{col_name}')
p.fig.text(0.4, 0, 'Sequencing cycle (nt)', fontsize = 15)
p.fig.text(0, 0.8, 'Per-lane-price (USD)', fontsize = 15, rotation=90)
```

![png]({{ site.baseurl }}/assets/article_images/sequencing_costs/compare_plot.png)


From the figure, it looks like UT Austin GSAF has a higher price for every sequencing type. 

For the comparison in HiSeq runs, GSAF is running HiSeq 4000 while MD Anderson Science Park is running HiSeq 3000, so that maybe one of the reason. For the other ones, seems like the machines are the same.
