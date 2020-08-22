---
layout: page
category : pages
title: COVID19 Maryland data
permalink: /COVID/
---
<script type='text/javascript' src='https://d1bxh8uas1mnw7.cloudfront.net/assets/embed.js'></script>

Maryland government recently released [COVID19 data at Zip-code-level](https://coronavirus.maryland.gov/), with nice dashboard visualization. But these data were not normalized to the population of each zip code and there's no time series analysis breaking down at zip code level. So I am using these data to look at: 

1. Cases per 1M population
2. Daily new cases

The code and data are released in a [GitHub repo](https://github.com/wckdouglas/covid19_MD) with a [MIT license](https://github.com/wckdouglas/covid19_MD/blob/master/LICENSE).

{% include COVID.html %}
