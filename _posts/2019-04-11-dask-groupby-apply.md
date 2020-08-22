---
layout: post
title: "Dask Groupby-apply"
date: 2019-04-11T04:16:37+00:00
---


I have been using [dask](https://dask.org/) for speeding up some larger scale analyses. Dask is a really great tool for inplace replacement for parallelizing some [pyData](https://pydata.org/downloads/)-powered analyses, such as [numpy](http://docs.dask.org/en/latest/array-creation.html#create-dask-arrays), [pandas](http://docs.dask.org/en/latest/array-creation.html#from-dask-dataframe) and even [scikit-learn](https://ml.dask.org/#dask-ml).  

However, I recently found an interesting case where using same syntax in ***dask.dataframe*** for ***pandas.dataframe*** does not acheive what I want. So in this post, I will document how to overcome it for my future self.


As usual, lets import all the useful libraries:


```python
import pandas as pd
import dask.dataframe as dd
```

I will use the famous [titanic dataset](https://www.kaggle.com/c/titanic) as an example to show that how **dask** can act weirdly under *groupby + apply* operations.


```python
titanic = pd.read_csv('http://web.stanford.edu/class/archive/cs/cs109/cs109.1166/stuff/titanic.csv')
titanic.head()
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
      <th>Survived</th>
      <th>Pclass</th>
      <th>Name</th>
      <th>Sex</th>
      <th>Age</th>
      <th>Siblings/Spouses Aboard</th>
      <th>Parents/Children Aboard</th>
      <th>Fare</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>0</td>
      <td>3</td>
      <td>Mr. Owen Harris Braund</td>
      <td>male</td>
      <td>22.0</td>
      <td>1</td>
      <td>0</td>
      <td>7.2500</td>
    </tr>
    <tr>
      <th>1</th>
      <td>1</td>
      <td>1</td>
      <td>Mrs. John Bradley (Florence Briggs Thayer) Cum...</td>
      <td>female</td>
      <td>38.0</td>
      <td>1</td>
      <td>0</td>
      <td>71.2833</td>
    </tr>
    <tr>
      <th>2</th>
      <td>1</td>
      <td>3</td>
      <td>Miss. Laina Heikkinen</td>
      <td>female</td>
      <td>26.0</td>
      <td>0</td>
      <td>0</td>
      <td>7.9250</td>
    </tr>
    <tr>
      <th>3</th>
      <td>1</td>
      <td>1</td>
      <td>Mrs. Jacques Heath (Lily May Peel) Futrelle</td>
      <td>female</td>
      <td>35.0</td>
      <td>1</td>
      <td>0</td>
      <td>53.1000</td>
    </tr>
    <tr>
      <th>4</th>
      <td>0</td>
      <td>3</td>
      <td>Mr. William Henry Allen</td>
      <td>male</td>
      <td>35.0</td>
      <td>0</td>
      <td>0</td>
      <td>8.0500</td>
    </tr>
  </tbody>
</table>
</div>



 I will illustrate the problem by counting how many survivors in each age and sex group, using the following function:


```python
def count_survival(d):
    '''
    summarize survivor, and return an dataframe for the single value-ed array
    '''
    return pd.DataFrame({'survived':[d.Survived.sum()]})
```

A regular **pandas** way to do it would be:


```python
titanic    \
    .groupby(['Age','Sex'])\
    .apply(count_survival)\
    .head()
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
      <th></th>
      <th></th>
      <th>survived</th>
    </tr>
    <tr>
      <th>Age</th>
      <th>Sex</th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0.42</th>
      <th>male</th>
      <th>0</th>
      <td>1</td>
    </tr>
    <tr>
      <th>0.67</th>
      <th>male</th>
      <th>0</th>
      <td>1</td>
    </tr>
    <tr>
      <th>0.75</th>
      <th>female</th>
      <th>0</th>
      <td>2</td>
    </tr>
    <tr>
      <th>0.83</th>
      <th>male</th>
      <th>0</th>
      <td>2</td>
    </tr>
    <tr>
      <th>0.92</th>
      <th>male</th>
      <th>0</th>
      <td>1</td>
    </tr>
  </tbody>
</table>
</div>



Lets translate the ***pandas.dataframe*** to a ***dask.dataframe*** and do the same


```python
dask_job = titanic \
    .pipe(dd.from_pandas, npartitions=24)\
    .groupby(['Age','Sex']) \
    .apply(count_survival, meta={'survived':'f8'}) 
```

This is not going to return any result until we do ```dask_job.compute()```, but **dask** also include a *visualize* function to show the task graph:


```python
dask_job.visualize()
```




![png]({{ site.baseurl }}/assets/article_images/dask_groupby_apply/failed.png)



The resultant task graph is much more complicated than I would've expected, and this is actually because [data shuffling](http://docs.dask.org/en/latest/dataframe-groupby.html) behind the scene. Suggested by [the dask documentation](http://docs.dask.org/en/latest/dataframe-groupby.html#difficult-cases), this issue can be resolved by setting a groupby key as index:


```python
dask_job = titanic \
    .set_index('Age')\
    .pipe(dd.from_pandas, npartitions=24)\
    .groupby(['Age','Sex']) \
    .apply(count_survival, meta={'survived':'f8'}) 
dask_job.visualize()
```




![png]({{ site.baseurl }}/assets/article_images/dask_groupby_apply/expected.png)


